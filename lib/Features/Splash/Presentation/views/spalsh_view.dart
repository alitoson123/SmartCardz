import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_cards/constant.dart';
import 'package:smart_cards/core/navigator/routes.dart';
import 'package:smart_cards/core/services/Shared_preferences_service/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/core/view_model/app_init_cubit/app_init_cubit.dart';
import 'package:smart_cards/core/view_model/app_init_cubit/app_init_states.dart';
import 'package:smart_cards/core/view_model/app_language_cubit/app_language_cubit.dart';
import 'package:smart_cards/core/view_model/app_theme_cubit/app_theme_cubit.dart';
import 'package:smart_cards/generated/l10n.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();

    context.read<AppInitCubit>().initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AppInitCubit, AppInitState>(
        listener: (context, state) async {
          if (state is AppInitSuccessState) {

      context.read<ThemeCubit>().loadInitialTheme();
      context.read<AppLanguageCubit>().loadInitialLanguage();


            final isLogin = SharedPreferencesService.instance.getBool(
              K_IS_LOGIN,
            );

            await Future.delayed(const Duration(milliseconds: 500));

            if (!mounted) return;

            if (isLogin == true) {
              context.go(AppRoutes.homeScreen);
            } else {
              context.go(AppRoutes.onBoardingPage);
            }
          }

          if (state is AppInitFailedState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errMessage)));
          }
        },
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                S.of(context).home,
                style: TextStyle(
                  fontSize: 36.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
              //    SizedBox(height: 20.h),
              //   const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
