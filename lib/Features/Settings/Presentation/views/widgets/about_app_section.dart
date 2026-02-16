import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/custom_divider.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/section_header.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/settings_group.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/settings_item.dart';
import 'package:smart_cards/constant.dart';
import 'package:smart_cards/generated/l10n.dart';

class AboutAppSection extends StatelessWidget {
  const AboutAppSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(title: S.of(context).AboutApp),
        // App info
        SettingsGroup(
          children: [
            SettingsItem(
              icon: Icons.info_outline,
              title: S.of(context).AboutApp,
            ),
            CustomDivider(),
            // App version
            SettingsItem(
              icon: Icons.verified_outlined,
              title: S.of(context).version,
              subtitle: K_APP_VERSION,
            ),
          ],
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}
