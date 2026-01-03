import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/app_language.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/app_theme.dart';
import 'package:smart_cards/constant.dart';
import 'package:smart_cards/core/navigator/routes.dart';
import 'package:smart_cards/core/utils/widgets/app_header.dart';
import 'package:smart_cards/core/services/Local_service/local_service_with_hive.dart';
import 'package:smart_cards/core/services/Shared_preferences_service/shared_preferences.dart';
import 'package:smart_cards/core/services/notifications_service/push_notification_service.dart';
import 'package:smart_cards/core/view_model/app_language_cubit/app_language_cubit.dart';
import 'package:smart_cards/core/view_model/app_language_cubit/app_language_states.dart';
import 'package:smart_cards/core/view_model/app_theme_cubit/app_theme_cubit.dart';
import 'package:smart_cards/core/view_model/app_theme_cubit/app_theme_states.dart';
import 'package:smart_cards/generated/l10n.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool isNotification = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppHeader(
                icon: Icons.settings_rounded,
                title: S.of(context).settingsTitle,
              ),
              SizedBox(height: 30.h),
              buildSectionHeader(S.of(context).Account),
              buildSettingsGroup([
                _buildListTile(
                  icon: Icons.email_outlined,
                  title: S.of(context).Email,
                  subtitle: LocalServiceWithHive().getUser()?.email ?? 'Email',
                ),
                _buildDivider(),
                _buildListTile(
                  icon: Icons.person_outline,
                  title: S.of(context).Plan,
                  subtitle: 'Free',
                ),
              ]),
              SizedBox(height: 24.h),

              buildSectionHeader(S.of(context).Notification),
              buildSettingsGroup([
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                  leading: const Icon(Icons.notifications_outlined),
                  title: Text(
                    S.of(context).Notification,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
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
              ]),
              SizedBox(height: 24.h),

              buildSectionHeader(S.of(context).language),
              buildSettingsGroup([
                BlocBuilder<AppLanguageCubit, AppLanguageState>(
                  builder: (context, state) {
                    return _buildListTile(
                      icon: Icons.language,
                      title: S.of(context).language,
                      subtitle: state.appLanguage == 'en'
                          ? 'English'
                          : 'العربية',
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
              ]),
              SizedBox(height: 24.h),

              buildSectionHeader(S.of(context).appearance),
              buildSettingsGroup([
                BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, state) {
                    return _buildListTile(
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
              ]),
              SizedBox(height: 24.h),

              buildSectionHeader(S.of(context).AboutApp),
              buildSettingsGroup([
                _buildListTile(
                  icon: Icons.info_outline,
                  title: S.of(context).AboutApp,
                ),
                _buildDivider(),
                _buildListTile(
                  icon: Icons.verified_outlined,
                  title: S.of(context).version,
                  subtitle: '1.0.0',
                ),
              ]),
              SizedBox(height: 24.h),

              buildSectionHeader(S.of(context).actions),
              buildSettingsGroup([
                _buildListTile(
                  icon: Icons.logout,
                  iconColor: Colors.red,
                  title: S.of(context).logout,
                  titleColor: Colors.red,
                  onTap: () async {
                    await logout(context);
                  },
                ),
              ]),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget buildSettingsGroup(List<Widget> children) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: theme.brightness == Brightness.light
              ? Colors.grey.shade200
              : Colors.white10,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    Widget? trailing,
    Color? iconColor,
    Color? titleColor,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      leading: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: (iconColor ?? theme.colorScheme.primary).withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: iconColor ?? theme.colorScheme.primary,
          size: 20.sp,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: titleColor ?? theme.textTheme.bodyLarge?.color,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(fontSize: 13.sp, color: theme.hintColor),
            )
          : null,
      trailing:
          trailing ??
          (onTap != null
              ? Icon(Icons.chevron_right_rounded, color: theme.hintColor)
              : null),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 0.5,
      indent: 56.w,
      endIndent: 16.w,
      color: Colors.grey.withOpacity(0.2),
    );
  }

  Future<void> logout(BuildContext context) async {
    await SharedPreferencesService.instance.remove(K_IS_LOGIN);
    await PushNotificationService.removeFcmToken();
    if (!context.mounted) return;

    context.go(AppRoutes.signInScreen);
  }
}
