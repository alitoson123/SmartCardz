import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/about_app_section.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/account_section.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/actions_section.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/appearance_section.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/language_section.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/notification_section.dart';
import 'package:smart_cards/core/utils/widgets/app_header.dart';
import 'package:smart_cards/generated/l10n.dart';

class SettingsViewBody extends StatelessWidget {
  const SettingsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // header
            AppHeader(
              icon: Icons.settings_rounded,
              title: S.of(context).settingsTitle,
            ),
            SizedBox(height: 30.h),
            // Account section
            AccountSection(),

            // Notification section
            NotificationSection(),

            // Language section
            LanguageSection(),

            // Appearance section
            AppearanceSection(),

            // About app section
            AboutAppSection(),

            // Actions section
            ActionsSection(),
          ],
        ),
      ),
    );
  }
}
