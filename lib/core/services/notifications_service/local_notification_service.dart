import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class localnotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static ontap(NotificationResponse datails) {}
  static Future<void> init() async {
    /* // init timezone handling
    tz.initializeTimeZones();
    final currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone.toString()));
*/
    InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@drawable/ic_notification'),
      iOS: DarwinInitializationSettings(),
    );
    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveBackgroundNotificationResponse: ontap,
      onDidReceiveNotificationResponse: ontap,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  static Future<void> showBasicNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'id_1',
          'basic_notification',
          channelDescription: 'basic_notification_description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
          icon: 'ic_notification',
          color: const Color(0xFF4A90E2),
          sound: RawResourceAndroidNotificationSound(
            'universfield_new_notification_051_494246.mp3'.split('.').first,
          ),
        );

    await flutterLocalNotificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: androidPlatformChannelSpecifics,
      ),
      payload: payload,
    );
  }

  static Future<void> showRepeatedNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'id_2',
          'repeated_notification',
          channelDescription: 'repeated_notification_description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
          icon: 'ic_notification',
          color: Color(0xFF4A90E2),
        );

    await flutterLocalNotificationsPlugin.periodicallyShow(
      id: id,
      title: title,
      body: body,
      repeatInterval: RepeatInterval.daily,
      notificationDetails: NotificationDetails(
        android: androidPlatformChannelSpecifics,
      ),
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  static Future<void> showSchduledNotification({
    int id = 4,
    required String title,
    required String body,
    required int hour,
    required int minute,
    required bool isrepeat,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'id_3',
          'scheduled_notification',
          channelDescription: 'scheduled_notification_description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
          icon: 'ic_notification',
          color: Color(0xFF4A90E2),
        );

    tz.initializeTimeZones();

    final currentTimeZoneRaw = await FlutterTimezone.getLocalTimezone();
    String currentTimeZone = currentTimeZoneRaw.toString();

    // Windows bug workaround: extract IANA timezone ID (e.g. "Africa/Cairo")
    if (currentTimeZone.contains('TimezoneInfo(')) {
      final startIndex = currentTimeZone.indexOf('TimezoneInfo(') + 13;
      final endIndex = currentTimeZone.indexOf(',', startIndex);
      if (endIndex != -1) {
        currentTimeZone = currentTimeZone
            .substring(startIndex, endIndex)
            .trim();
      }
    }
    log("Extracted Timezone: $currentTimeZone");

    try {
      tz.setLocalLocation(tz.getLocation(currentTimeZone));
    } catch (e) {
      log("Error setting location, falling back to UTC: $e");
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: androidPlatformChannelSpecifics,
      ),
      payload: 'zonedSchedule',
      // Android specific: Allow notification while device is in low-power mode
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      // Make notification repeat DAILY at same time
      matchDateTimeComponents: isrepeat == true
          ? DateTimeComponents.time
          : null,
    );
  }

  static Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id: id);
  }

  static void cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
