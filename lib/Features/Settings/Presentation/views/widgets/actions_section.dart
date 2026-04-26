import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/section_header.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/settings_group.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/settings_item.dart';
import 'package:smart_cards/constant.dart';
import 'package:smart_cards/core/navigator/routes.dart';
import 'package:smart_cards/core/services/Shared_preferences_service/shared_preferences.dart';
import 'package:smart_cards/core/services/notifications_service/push_notification_service.dart';
import 'package:smart_cards/generated/l10n.dart';

class ActionsSection extends StatelessWidget {
  const ActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(title: S.of(context).actions),
        SettingsGroup(
          children: [
            SettingsItem(
              icon: Icons.logout,
              iconColor: Colors.red,
              title: S.of(context).logout,
              titleColor: Colors.red,
              trailing: Icon(Icons.chevron_right_rounded, size: 24.sp),
              onTap: () async {
                await logout(context);
              },
            ),
          ],
        ),
        SizedBox(height: 40.h),
      ],
    );
  }

  Future<void> logout(BuildContext context) async {
    await SharedPreferencesService.instance.remove(K_IS_LOGIN);
    // await PushNotificationService.removeFcmToken();
    if (!context.mounted) return;

    context.go(AppRoutes.signInScreen);
  }
}
