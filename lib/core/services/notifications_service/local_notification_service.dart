import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class localnotificationService {
static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
static  ontap (NotificationResponse datails) {}
  static Future<void> init() async {
    InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: ontap,
      onDidReceiveNotificationResponse: ontap,
    );
  }

 static Future<void> showBasicNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'id_1', //
          'basic_notification', //
          channelDescription: 'basic_notification_description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      1,
      message.notification?.title ?? 'New Notification',
      message.notification?.body ?? 'the body',
      platformChannelSpecifics,
      payload: message.data.toString(),
    );
  }

 static Future<void> showRepeatedNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'id_2', //
          'repeated_notification', //
          channelDescription: 'repeated_notification_description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.periodicallyShow(
      2,
      message.notification?.title ?? 'New Notification',
      message.notification?.body ?? 'the body',
      RepeatInterval.everyMinute,
      platformChannelSpecifics,
      payload: message.data.toString(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

 static Future<void> cancelNotification(int id) async {
   await flutterLocalNotificationsPlugin.cancel(id);
  }
}
