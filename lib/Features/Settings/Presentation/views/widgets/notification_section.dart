import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/section_header.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/settings_group.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/settings_item.dart';
import 'package:smart_cards/generated/l10n.dart';

class NotificationSection extends StatefulWidget {
  const NotificationSection({super.key});

  @override
  State<NotificationSection> createState() => _NotificationSectionState();
}

class _NotificationSectionState extends State<NotificationSection> {
  bool isNotification = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(title: S.of(context).Notification),
        SettingsGroup(
          children: [
            SettingsItem(
              icon:  Icons.notifications_outlined,
              title:  S.of(context).Notification,
              trailing: Switch(
                value: isNotification,
                onChanged: (value) {
                  setState(() {
                    isNotification = value;
                  });
                },
              ),
              onTap: () {
                setState(() {
                  isNotification = !isNotification;
                });
              },
            ),
          ],
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}
