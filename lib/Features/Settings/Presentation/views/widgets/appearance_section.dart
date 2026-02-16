import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/app_theme.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/section_header.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/settings_group.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/settings_item.dart';
import 'package:smart_cards/core/view_model/app_theme_cubit/app_theme_cubit.dart';
import 'package:smart_cards/core/view_model/app_theme_cubit/app_theme_states.dart';
import 'package:smart_cards/generated/l10n.dart';

class AppearanceSection extends StatelessWidget {
  const AppearanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(title: S.of(context).appearance),
        SettingsGroup(
          children: [
            BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, state) {
                return SettingsItem(
                  icon: Icons.palette_outlined,
                  title: S.of(context).theme,
                  subtitle: state.themeMode == ThemeMode.dark
                      ? S.of(context).dark
                      : S.of(context).light,
                  trailing: Icon(Icons.chevron_right_rounded, size: 24.sp),
                  onTap: () async {
                    final selectedTheme = await showDialog(
                      context: context,
                      builder: (context) => AppTheme(
                        initialTheme: state.themeMode == ThemeMode.dark
                            ? S.of(context).dark
                            : S.of(context).light,
                      ),
                    );

                    if (selectedTheme != null) {
                      context.read<ThemeCubit>().changeTheme(selectedTheme);
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
