import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
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
  Timer? _safetyTimeoutTimer;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    // Failsafe: Never stay stuck on splash screen for more than 3 seconds
    _safetyTimeoutTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && !_hasNavigated) {
        _navigateNext();
      }
    });

    context.read<AppInitCubit>().initialize();
  }

  @override
  void dispose() {
    _safetyTimeoutTimer?.cancel();
    super.dispose();
  }

  Future<void> _navigateNext() async {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;
    _safetyTimeoutTimer?.cancel();

    try {
      context.read<ThemeCubit>().loadInitialTheme();
      context.read<AppLanguageCubit>().loadInitialLanguage();
    } catch (_) {}

    bool isLoggedIn = false;
    try {
      final isLoginPref = SharedPreferencesService.instance.getBool(
        AppConstants.K_IS_LOGIN,
      );
      final firebaseUser = FirebaseAuth.instance.currentUser;
      isLoggedIn = isLoginPref == true && firebaseUser != null;

      if (!isLoggedIn) {
        if (firebaseUser != null) {
          await FirebaseAuth.instance.signOut();
        }
        if (isLoginPref == true) {
          await SharedPreferencesService.instance.setBool(
            AppConstants.K_IS_LOGIN,
            false,
          );
        }
      }
    } catch (_) {}

    if (!mounted) return;

    if (isLoggedIn) {
      context.go(AppRoutes.homeScreen);
    } else {
      context.go(AppRoutes.onBoardingPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AppInitCubit, AppInitState>(
        listener: (context, state) async {
          if (state is AppInitSuccessState || state is AppInitFailedState) {
            await Future.delayed(const Duration(milliseconds: 500));
            if (mounted) {
              _navigateNext();
            }
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
            ],
          ),
        ),
      ),
    );
  }
}
