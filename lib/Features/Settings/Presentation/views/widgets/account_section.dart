import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/custom_divider.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/section_header.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/settings_group.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/settings_item.dart';
import 'package:smart_cards/core/services/Local_service/local_service_with_hive.dart';
import 'package:smart_cards/generated/l10n.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(title: S.of(context).Account),
        SettingsGroup(
          children: [
            // Email
            SettingsItem(
              icon: Icons.email_outlined,
              title: S.of(context).Email,
              subtitle: LocalServiceWithHive().getUser()?.email ?? 'Email',
            ),
            CustomDivider(),
            // Plan
            SettingsItem(
              icon: Icons.person_outline,
              title: S.of(context).Plan,
              subtitle: S.of(context).free,
            ),
          ],
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}
