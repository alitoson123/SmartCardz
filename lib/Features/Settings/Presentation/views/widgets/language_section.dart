import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/app_language.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/section_header.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/settings_group.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/settings_item.dart';
import 'package:smart_cards/core/view_model/app_language_cubit/app_language_cubit.dart';
import 'package:smart_cards/core/view_model/app_language_cubit/app_language_states.dart';
import 'package:smart_cards/generated/l10n.dart';

class LanguageSection extends StatelessWidget {
  const LanguageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(title: S.of(context).language),
        SettingsGroup(
          children: [
            BlocBuilder<AppLanguageCubit, AppLanguageState>(
              builder: (context, state) {
                return SettingsItem(
                  icon: Icons.language,
                  title: S.of(context).language,
                  subtitle: state.appLanguage == 'en' ? 'English' : 'العربية',
                  trailing: Icon(Icons.chevron_right_rounded, size: 24.sp),
                  onTap: () async {
                    final selectedLanguage = await showDialog(
                      context: context,
                      builder: (context) =>
                          AppLanguage(initialLanguage: state.appLanguage),
                    );

                    if (selectedLanguage != null) {
                      context.read<AppLanguageCubit>().changeLanguage(
                        selectedLanguage,
                      );
                    }
                  },
                );
              },
            ),
          ],
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}
