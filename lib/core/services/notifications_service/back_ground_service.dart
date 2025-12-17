import 'package:background_fetch/background_fetch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_cards/core/services/Local_service/local_service_with_hive.dart';

const int DUE_CARDS_THRESHOLD = 10;
const int INACTIVE_DAYS_THRESHOLD = 0;
const String LAST_OPENED_KEY = 'last_opened_iso';
const String CARDS_COLLECTION = 'cards';
const String USERS_COLLECTION = 'users';

class BackGroundService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final firebaseMessage = FirebaseMessaging.instance;

  Future<void> initBackgroundFetch() async {
    // إعدادات عامة
    BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval:
            180, // دقائق على Android (هنا 180 = كل 3 ساعات مقترح)
        stopOnTerminate: false,
        enableHeadless: true,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiredNetworkType: NetworkType.ANY,
      ),
      onBackgroundFetch,
      onBackgroundFetchTimeout,
    );
  }

  Future<void> onBackgroundFetch(String taskId) async {
    // هذا الكود يعمل في الـ main isolate أيضاً عند الـ periodic fetch
    await backgroundWork();
    BackgroundFetch.finish(taskId);
  }

  void onBackgroundFetchTimeout(String taskId) {
    BackgroundFetch.finish(taskId);
  }

  Future<void> updateLastOpened() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(LAST_OPENED_KEY, DateTime.now().toIso8601String());

    // لو بتحب تحدث هذا الحقل في Firestore للمستخدم:
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection(USERS_COLLECTION)
          .doc(user.uid)
          .set({
            'lastOpened': Timestamp.fromDate(DateTime.now()),
          }, SetOptions(merge: true));
    }
  }

  Future<void> backgroundWork() async {
    try {
      await checkDueCards();

      // استنى ثانية قبل الإشعار التاني
      await Future.delayed(Duration(seconds: 2));

      await checkInactiveUser();
    } catch (e, st) {
      print('backgroundWork error: $e\n$st');
    }
  }

  /// دالة عرض Notification محلي
  Future<void> showLocalNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'channel_id_default',
      'General Notifications',
      channelDescription: 'General notifications channel',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const platform = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000, // id فريد
      title,
      body,
      platform,
    );
  }

  /// تهيئة الإشعارات المحلية
  Future<void> initLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        // لو حبيت تتعامل مع الضغط على الإشعار
        // final payload = response.payload;
        print('Notification clicked');
      },
    );
  }

  void subscribeToTopics() {
    firebaseMessage.subscribeToTopic('all');
  }

  /// ====== الوظائف الخاصة بالحالتين ======

  Future<void> checkDueCards() async {
    final uid = await _getUserId();
    if (uid == null) return _skipCheck("No UID found");

    final now = DateTime.now();
    final todayStr = _formatDate(now);

    final collections = await _fetchUserCollections(uid);
    final dueCardsCount = await _countDueCards(collections);

    await handleDueNotificationTest(dueCardsCount, todayStr);
  }

  /// ----------------- Helper Methods -----------------

  Future<String?> _getUserId() async {
    return LocalServiceWithHive().getUser()?.useruid;
  }

  Future<void> _skipCheck(String reason) async {
    print('checkDueCards: $reason → skipped');
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  Future<List<String>> _fetchUserCollections(String uid) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('collections')
        .where('ownerId', isEqualTo: uid)
        .get();

    return snapshot.docs.map((e) => e.id).toList();
  }

  Future<int> _countDueCards(List<String> collectionIds) async {
    if (collectionIds.isEmpty) return 0;

    final nowTs = Timestamp.fromDate(DateTime.now());

    final snap = await FirebaseFirestore.instance
        .collection('cards')
        .where('collectionId', whereIn: collectionIds)
        .where('next_review', isLessThanOrEqualTo: nowTs)
        .get();

    return snap.docs.length;
  }

  Future<void> handleDueNotificationTest(int count, String today) async {
    print('Due cards today: $count');

    final prefs = await SharedPreferences.getInstance();
    // final lastDate = prefs.getString('last_due_notif_date');

    if (count >= DUE_CARDS_THRESHOLD) {
      await showLocalNotification(
        title: 'مجدول للمراجعة',
        body: 'عندك $count بطاقة تحتاج مراجعة النهاردة.',
      );

      await prefs.setString('last_due_notif_date', today);
    }
  }

  Future<void> handleDueNotification(int count, String today) async {
    print('Due cards today: $count');

    final prefs = await SharedPreferences.getInstance();
    final lastDate = prefs.getString('last_due_notif_date');

    // لو مفيش إشعار قبل كده — اعتبرك محتاج تبعته
    if (lastDate == null) {
      await showLocalNotification(
        title: 'مجدول للمراجعة',
        body: 'عندك $count بطاقة تحتاج مراجعة.',
      );
      await prefs.setString('last_due_notif_date', today);
      return;
    }

    // احسب فرق الأيام
    final last = DateTime.parse(lastDate); // من نوع yyyy-MM-dd
    final now = DateTime.now();
    final diff = now.difference(last).inDays;

    print("Days since last due notification: $diff");

    // لازم يكون 5 أيام أو أكتر
    if (count >= DUE_CARDS_THRESHOLD && diff >= 5) {
      await showLocalNotification(
        title: 'مجدول للمراجعة',
        body: 'عدّى $diff يوم — عندك $count بطاقة محتاجة مراجعة.',
      );

      await prefs.setString('last_due_notif_date', today);
    }
  }

  Future<void> checkInactiveUser() async {
    final prefs = await SharedPreferences.getInstance();
    final lastOpenIso = prefs.getString(LAST_OPENED_KEY);

    if (lastOpenIso == null) {
      // لو مسبتش آخر فتح، ممكن نعتبره في المدى أو نعمل إميل
      print('checkInactiveUser: no last_opened saved -> skip');
      return;
    }

    final lastOpen = DateTime.parse(lastOpenIso);
    final diffDays = DateTime.now().difference(lastOpen).inDays;
    print('Days since last open: $diffDays');

    if (diffDays >= INACTIVE_DAYS_THRESHOLD) {
      await showLocalNotification(
        title: 'وحشتنا!',
        body:
            'مدّيت $diffDays يوم من غير ما تفتح التطبيق — ارجع راجع بطاقاتك.',
      );
      // لو عايز تمنع التكرار: حدث last_opened ليوم النهارده أو خزّن flag أن الاشعار اتبعت
      // مثلاً:
      await prefs.setString(LAST_OPENED_KEY, DateTime.now().toIso8601String());
    }
  }
}
