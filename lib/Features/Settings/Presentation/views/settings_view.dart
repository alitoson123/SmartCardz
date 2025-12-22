import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/app_language.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/app_theme.dart';
import 'package:smart_cards/constant.dart';
import 'package:smart_cards/core/navigator/routes.dart';
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
      appBar: AppBar(title: Text(S.of(context).settingsTitle)),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 30.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).Account,
                style: TextStyle(fontSize: 20.sp, color: Colors.grey.shade600),
              ),
              SizedBox(height: 10.h),

              Container(
                padding: EdgeInsets.all(5.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.email_outlined, size: 30),
                      title: Text(
                        S.of(context).Email,
                        style: TextStyle(fontSize: 20.sp),
                      ),
                      subtitle: Text(
                        LocalServiceWithHive().getUser()?.email ?? 'Email',
                        style: TextStyle(fontSize: 18.sp),
                      ),
                    ),
                    const Divider(color: Colors.grey, thickness: .4, height: 4),
                    ListTile(
                      leading: const Icon(Icons.person_outline, size: 30),
                      title: Text(
                        S.of(context).Plan,
                        style: TextStyle(fontSize: 20.sp),
                      ),
                      subtitle: Text('Free', style: TextStyle(fontSize: 18.sp)),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15.h),

              Text(
                S.of(context).Notification,
                style: TextStyle(fontSize: 20.sp, color: Colors.grey.shade600),
              ),
              SizedBox(height: 10.h),

              Container(
                padding: EdgeInsets.all(5.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: ListTile(
                  leading: const Icon(Icons.notifications_outlined),
                  title: Text(
                    S.of(context).Notification,
                    style: TextStyle(fontSize: 20.sp),
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
              ),

              SizedBox(height: 15.h),

              Text(
                S.of(context).language,
                style: TextStyle(fontSize: 20.sp, color: Colors.grey.shade600),
              ),
              SizedBox(height: 10.h),

              Container(
                padding: EdgeInsets.all(5.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: BlocBuilder<AppLanguageCubit, AppLanguageState>(
                  builder: (context, state) {
                    return ListTile(
                      leading: const Icon(Icons.language),
                      title: Text(
                        S.of(context).language,
                        style: TextStyle(fontSize: 20.sp),
                      ),
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
              ),
              Text(
                S.of(context).appearance,
                style: TextStyle(fontSize: 20.sp, color: Colors.grey.shade600),
              ),
              SizedBox(height: 10.h),

              Container(
                padding: EdgeInsets.all(5.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, state) {
                    return ListTile(
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
                      leading: Icon(Icons.palette_outlined, size: 30.sp),
                      title: Text(
                        S.of(context).theme,
                        style: TextStyle(fontSize: 20.sp),
                      ),
                      subtitle: Text(
                        state.themeMode == ThemeMode.dark
                            ? S.of(context).dark
                            : S.of(context).light,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 18.sp),
                    );
                  },
                ),
              ),
              SizedBox(height: 15.h),

              Text(
                S.of(context).AboutApp,
                style: TextStyle(fontSize: 20.sp, color: Colors.grey.shade600),
              ),
              SizedBox(height: 10.h),

              Container(
                padding: EdgeInsets.all(5.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: Text(
                        S.of(context).AboutApp,
                        style: TextStyle(fontSize: 20.sp),
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: Text(
                        S.of(context).version,
                        style: TextStyle(fontSize: 20.sp),
                      ),
                      subtitle: Text(
                        '1.0.0',
                        style: TextStyle(fontSize: 18.sp),
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.h),

              Text(
                S.of(context).actions,
                style: TextStyle(fontSize: 20.sp, color: Colors.grey.shade600),
              ),
              SizedBox(height: 10.h),

              Container(
                padding: EdgeInsets.all(5.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: Text(
                    S.of(context).logout,
                    style: TextStyle(fontSize: 20.sp),
                  ),
                  onTap: () async {
                    await logout(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await SharedPreferencesService.instance.remove(K_IS_LOGIN);
    await PushNotificationService.removeFcmToken();
    if (!context.mounted) return;

    context.go(AppRoutes.signInScreen);
  }
}
