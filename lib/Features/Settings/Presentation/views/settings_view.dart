import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/app_language.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/app_theme.dart';
import 'package:smart_cards/constant.dart';
import 'package:smart_cards/core/navigator/routes.dart';
import 'package:smart_cards/core/services/Local_service/local_service_with_hive.dart';
import 'package:smart_cards/core/services/Shared_preferences_service/shared_preferences.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).Account,
                style: TextStyle(fontSize: 20, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.email_outlined, size: 30),
                      title: Text(
                        S.of(context).Email,
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle: Text(
                        LocalServiceWithHive().getUser()?.email ?? 'Email',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    const Divider(color: Colors.grey, thickness: .4, height: 4),
                    ListTile(
                      leading: const Icon(Icons.person_outline, size: 30),
                      title: Text(
                        S.of(context).Plan,
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle: Text('Free', style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              Text(
                S.of(context).Notification,
                style: TextStyle(fontSize: 20, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: const Icon(Icons.notifications_outlined),
                  title: Text(
                    S.of(context).Notification,
                    style: TextStyle(fontSize: 20),
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

              const SizedBox(height: 15),

              Text(
                S.of(context).language,
                style: TextStyle(fontSize: 20, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: BlocBuilder<AppLanguageCubit, AppLanguageState>(
                  builder: (context, state) {
                    return ListTile(
                      leading: const Icon(Icons.language),
                      title: Text(
                        S.of(context).language,
                        style: TextStyle(fontSize: 20),
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
                style: TextStyle(fontSize: 20, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
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
                      leading: const Icon(Icons.palette_outlined, size: 30),
                      title: Text(
                        S.of(context).theme,
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle: Text(
                        state.themeMode == ThemeMode.dark
                            ? S.of(context).dark
                            : S.of(context).light,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),

              Text(
                S.of(context).AboutApp,
                style: TextStyle(fontSize: 20, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: Text(
                        S.of(context).AboutApp,
                        style: TextStyle(fontSize: 20),
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: Text(
                        S.of(context).version,
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle: Text('1.0.0', style: TextStyle(fontSize: 18)),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              Text(
                S.of(context).actions,
                style: TextStyle(fontSize: 20, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: Text(
                    S.of(context).logout,
                    style: TextStyle(fontSize: 20),
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

    if (!context.mounted) return;

    context.go(AppRoutes.signInScreen);
  }
}
