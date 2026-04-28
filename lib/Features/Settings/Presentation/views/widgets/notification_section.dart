import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/section_header.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/settings_group.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/settings_item.dart';
import 'package:smart_cards/core/services/Shared_preferences_service/shared_preferences.dart';
import 'package:smart_cards/core/services/notifications_service/local_notification_service.dart';
import 'package:smart_cards/generated/l10n.dart';

class NotificationSection extends StatefulWidget {
  const NotificationSection({super.key});

  @override
  State<NotificationSection> createState() => _NotificationSectionState();
}

class _NotificationSectionState extends State<NotificationSection> {
  late bool isNotification;

  @override
  void initState() {
    super.initState();
    // Defaults to true for the first time
    isNotification =
        SharedPreferencesService.instance.getBool('is_reminder_active') ?? true;
  }

  void _toggleNotification(bool value) async {
    final prefs = SharedPreferencesService.instance;

    setState(() {
      isNotification = value;
    });

    if (value) {
      // User turned ON the switch: schedule reminder with saved data or defaults
      final int hour = prefs.getInt('reminder_hour') ?? 5;
      final String period = prefs.getString('reminder_period') ?? 'PM';
      final bool repeatDaily = prefs.getBool('reminder_repeat_daily') ?? true;

      final String title =
          prefs.getString('reminder_title') ?? S.of(context).timeToStudy;
      final String message =
          prefs.getString('reminder_message') ??
          S.of(context).yourCardsAreWaitingKeepYourStreakAlive;

      final int hour24 = period == 'PM' ? (hour % 12) + 12 : hour % 12;

      await localnotificationService.showSchduledNotification(
        id: 4,
        title: title,
        body: message,
        hour: hour24,
        minute: 0,
        isrepeat: repeatDaily,
      );

      await prefs.setBool('is_reminder_active', true);
    } else {
      // User turned OFF the switch: cancel the reminder
      await localnotificationService.cancelNotification(4);
      await prefs.setBool('is_reminder_active', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(title: S.of(context).Notification),
        SettingsGroup(
          children: [
            SettingsItem(
              icon: Icons.notifications_outlined,
              title: S.of(context).Notification,
              trailing: Switch(
                value: isNotification,
                activeThumbColor: Theme.of(context).colorScheme.primary,
                onChanged: _toggleNotification,
              ),
              onTap: () => _toggleNotification(!isNotification),
            ),
          ],
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}
