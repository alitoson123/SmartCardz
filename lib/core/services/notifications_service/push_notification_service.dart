import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  static final FirebaseMessaging messaging = FirebaseMessaging.instance;

  static Future<void> init() async {
    await requestPermission();
    listenForTokenRefresh();
  }

  static Future<void> requestPermission() async {
    await messaging.requestPermission(alert: true, badge: true, sound: true);
  }

  static Future<void> saveToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final token = await messaging.getToken();
    if (token == null) return;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'fcmToken': token,
    }, SetOptions(merge: true));
  }

  static void listenForTokenRefresh() {
    messaging.onTokenRefresh.listen((newToken) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'fcmToken': newToken,
      }, SetOptions(merge: true));
    });
  }

  static Future<void> removeFcmToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'fcmToken': FieldValue.delete(),
    });

    await messaging.deleteToken();
  }
}

/*
  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp();
    log("Handling a background message: ${message.messageId}");
  }

  static void myOnMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print(
          'Message also contained a notification: ${message.notification!.title}',
        );
        print(
          'Message also contained a notification: ${message.notification!.body}',
        );

        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  static void sendMyToken(String token) {}
}
*/
/*import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:googleapis_auth/auth_io.dart';

class FirebaseApi {
  final _firebaseMessage = FirebaseMessaging.instance;
  final _messageStream = FirebaseMessaging.onMessage;
  static String? userToken;
  static String? adminToken;

  Stream<RemoteMessage> get messageStream => _messageStream;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    final adminDoc = await FirebaseFirestore.instance
        .collection('admins')
        .doc('a.ali2672@su.edu.eg')
        .get();

    adminToken = adminDoc.data()?['fcmToken'];

    await _firebaseMessage.requestPermission();
    await _initLocalNotification();

    userToken = await _firebaseMessage.getToken();
    log('FCM Token: $userToken');
    log('Admin Token: $adminToken');

    iniPushNotification();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Foreground message received: ${message.data}');
      showNotification(message);
    });
  }

  void handleNotification(RemoteMessage? message) {
    if (message == null) return;

    log('Notification received: ${message.data}');
    showNotification(message);
  }

  Future iniPushNotification() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleNotification);
    FirebaseMessaging.onMessageOpenedApp.listen(handleNotification);
  }

  Future<void> _initLocalNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        final payload = response.payload;
        log('Notification clicked with payload: $payload');
      },
    );
  }

  Future<void> showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'your_channel_id', //
          'your_channel_name', // 
          channelDescription: 'your_channel_description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? 'New Notification',
      message.notification?.body ?? '',
      platformChannelSpecifics,
      payload: message.data.toString(),
    );
  }
}

class FcmSender {
  final String _serviceAccountJsonPath;
  final String _projectId;
  late AutoRefreshingAuthClient _client;

  FcmSender(this._serviceAccountJsonPath, this._projectId);

  Future<void> init() async {
    final accountCredentials = ServiceAccountCredentials.fromJson(
      await readServiceAccountFromAssets(),
    );

    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

    _client = await clientViaServiceAccount(accountCredentials, scopes);
  }

  Future<bool> sendNotification({
    required String deviceToken,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    final url =
        'https://fcm.googleapis.com/v1/projects/$_projectId/messages:send';

    final message = {
      "message": {
        "token": deviceToken,
        "notification": {"title": title, "body": body},
        if (data != null) "data": data,
      },
    };

    final response = await _client.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully!');
      return true;
    } else {
      print(
        'Failed to send notification: ${response.statusCode} - ${response.body}',
      );
      return false;
    }
  }

  void close() {
    _client.close();
  }

  Future<Map<String, dynamic>> readServiceAccountFromAssets() async {
    final jsonStr = await rootBundle.loadString('assets/service-account.json');
    return jsonDecode(jsonStr);
  }

}
*/
