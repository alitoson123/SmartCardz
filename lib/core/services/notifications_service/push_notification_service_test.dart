/*import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:googleapis_auth/auth_io.dart';

class FirebaseApi {
  final firebaseMessage = FirebaseMessaging.instance;
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

    await firebaseMessage.requestPermission();
    await initLocalNotification();

    userToken = await firebaseMessage.getToken();
    log('FCM Token: $userToken');
    log('Admin Token: $adminToken');

    interactionPushNotification();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Foreground message received: ${message.data}');
      showNotification(message);
      firebaseMessage.subscribeToTopic('all');

      //  firebaseMessage.unsubscribeFromTopic('all');  we use it in logout
    });
  }

  void handleNotification(RemoteMessage? message) {
    if (message == null) return;

    if (message.data['type'] == 'home') {
      //  context.push(AppRoutes.homeScreen);
    }
    showNotification(message);
  }

  Future interactionPushNotification() async {
    FirebaseMessaging.instance.getInitialMessage().then(
      handleNotification,
    ); // terminated
    FirebaseMessaging.onMessageOpenedApp.listen(
      handleNotification,
    ); // background
  }

  Future<void> initLocalNotification() async {
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
          'my_id', //
          'my_channel_name', //
          channelDescription: 'my_channel_description',
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
    final jsonStr = await rootBundle.loadString(
      'assets/smart-cards-c1327-firebase-adminsdk-fbsvc-6057146e98.json',
    );
    return jsonDecode(jsonStr);
  }
}
*/