import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/section_header.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/settings_group.dart';
import 'package:smart_cards/Features/Settings/Presentation/views/widgets/settings_item.dart';
import 'package:smart_cards/constant.dart';
import 'package:smart_cards/core/navigator/routes.dart';
import 'package:smart_cards/core/services/Shared_preferences_service/shared_preferences.dart';
import 'package:smart_cards/generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Auth/Sign_in/Presentation/view_model/sign_in_cubit/sign_in_cubit.dart';
import 'package:smart_cards/Features/Auth/Sign_in/Presentation/view_model/sign_in_cubit/sign_in_states.dart';
import 'package:smart_cards/core/services/locator_service/service_locator.dart';
import 'package:smart_cards/Features/Auth/Data/Repos/auth_repo_impl.dart';

class ActionsSection extends StatelessWidget {
  const ActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInCubit(getIt<AuthRepoImpl>()),
      child: BlocListener<SignInCubit, SignInStates>(
        listener: (context, state) {
          if (state is SignInErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errMessage)),
            );
          } else if (state is DeleteAccountSuccessState) {
            // Delete local data and navigate to login
            SharedPreferencesService.instance.remove(K_IS_LOGIN);
            context.go(AppRoutes.signInScreen);
          }
        },
        child: Builder(
          builder: (context) {
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
                    SettingsItem(
                      icon: Icons.delete_forever,
                      iconColor: Colors.red,
                      title: 'Delete Account',
                      titleColor: Colors.red,
                      trailing: Icon(Icons.chevron_right_rounded, size: 24.sp),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            title: const Text('Delete Account'),
                            content: const Text(
                              'Are you sure you want to permanently delete your account? All your collections, flashcards, and data will be lost. This action cannot be undone.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext); // Close dialog
                                  BlocProvider.of<SignInCubit>(context).deleteAccountMethod();
                                },
                                child: const Text('Delete', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 40.h),
              ],
            );
          }
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await SharedPreferencesService.instance.remove(K_IS_LOGIN);
    // await PushNotificationService.removeFcmToken();
    if (!context.mounted) return;

    context.go(AppRoutes.signInScreen);
  }
}
