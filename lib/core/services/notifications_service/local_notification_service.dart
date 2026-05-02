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
    // init timezone handling
    try {
      tz.initializeTimeZones();
    } catch (e) {
      debugPrint('initializeTimeZones failed: $e');
    }

    bool timezoneSet = false;

    try {
      final currentTimeZoneRaw = await FlutterTimezone.getLocalTimezone();
      final String currentTimeZone = currentTimeZoneRaw.toString();

      // 1. Try to set it directly
      try {
        tz.setLocalLocation(tz.getLocation(currentTimeZone));
        timezoneSet = true;
      } catch (_) {}

      // 2. If it fails, extract the IANA Timezone ID using Regex
      if (!timezoneSet) {
        try {
          final RegExp regex = RegExp(r'([a-zA-Z_]+(?:/[a-zA-Z_]+)+)');
          final match = regex.firstMatch(currentTimeZone);
          if (match != null) {
            tz.setLocalLocation(tz.getLocation(match.group(0)!));
            timezoneSet = true;
          }
        } catch (_) {}
      }
    } catch (e) {
      debugPrint('Failed to get local timezone from device: $e');
    }

    // 3. Fallback attempts
    if (!timezoneSet) {
      final List<String> fallbackTimezones = [
        'Africa/Cairo', // User's local timezone
        'Asia/Riyadh',
        'UTC',
        'GMT',
      ];

      for (final fallback in fallbackTimezones) {
        try {
          tz.setLocalLocation(tz.getLocation(fallback));
          timezoneSet = true;
          break;
        } catch (_) {}
      }
    }

    // 4. Ultimate fallback: Use any available timezone from the database to prevent crash
    if (!timezoneSet) {
      try {
        if (tz.timeZoneDatabase.locations.isNotEmpty) {
          tz.setLocalLocation(tz.timeZoneDatabase.locations.values.first);
        }
      } catch (_) {}
    }

    // log(tz.local.toString());

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

    // Reliance on global initialization in init()
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
