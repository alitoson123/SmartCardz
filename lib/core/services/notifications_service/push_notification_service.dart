import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class PushNotificationService {
  static final FirebaseMessaging messaging = FirebaseMessaging.instance;

  static Future<void> init() async {
    try {
      await requestPermission();
      await saveToken();
      listenForTokenRefresh();
      listenToForegroundMessages();
    } catch (e) {
      debugPrint('PushNotificationService init failed: $e');
    }
  }

  static Future<void> requestPermission() async {
    try {
      await messaging.requestPermission(alert: true, badge: true, sound: true);
    } catch (e) {
      debugPrint('Error requesting permission: $e');
    }
  }

  static Future<void> saveToken() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final token = await messaging.getToken();
      if (token == null) return;

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'fcmToken': token,
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error saving token: $e');
    }
  }

  static void listenForTokenRefresh() {
    try {
      messaging.onTokenRefresh.listen((newToken) async {
        try {
          final user = FirebaseAuth.instance.currentUser;
          if (user == null) return;

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({'fcmToken': newToken}, SetOptions(merge: true));
        } catch (e) {
          debugPrint('Error updating refreshed token: $e');
        }
      });
    } catch (e) {
      debugPrint('Error setting up token refresh listener: $e');
    }
  }

  static Future<void> removeFcmToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'fcmToken': FieldValue.delete(),
    });

    await messaging.deleteToken();
  }

  static void listenToForegroundMessages() {
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('Foreground notification received');
    });
  }

  static void handleNotificationTap(BuildContext context) {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _navigate(context, message.data);
    });
  }

  static Future<void> handleInitialMessage(BuildContext context) async {
    final message = await messaging.getInitialMessage();
    if (message != null) {
      _navigate(context, message.data);
    }
  }

  static void _navigate(BuildContext context, Map<String, dynamic> data) {
    if (data['type'] == 'ai_preview') {
      Navigator.pushNamed(context, '/ai-preview', arguments: data['requestId']);
    }
  }
}
