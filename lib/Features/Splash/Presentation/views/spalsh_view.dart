import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_cards/constant.dart';
import 'package:smart_cards/core/navigator/routes.dart';
import 'package:smart_cards/core/services/Shared_preferences_service/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    goNext();
  }

  Future<void> goNext() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;

    final isLogin = SharedPreferencesService.instance.getBool(K_IS_LOGIN);

    if (isLogin == true) {
      context.go(AppRoutes.homeScreen);
    } else {
      context.go(AppRoutes.onBoardingPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Smart Cardz",
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
    );
  }
}
