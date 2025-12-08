import 'package:flutter/material.dart';
import 'package:smart_cards/Features/On_Boarding/Data/models/onboarding_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Onboardingitem extends StatelessWidget {
  const Onboardingitem({super.key, required this.onboardingModel});
  final OnboardingModel onboardingModel;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'SmartCardz',
          style: TextStyle(
            color: Color(0xff1E88E5),
            fontSize: 50.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 40.h),
        Image.asset(onboardingModel.image, height: 300.h, fit: BoxFit.contain),
        SizedBox(height: 40.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            onboardingModel.description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.sp, height: 1.5),
          ),
        ),
      ],
    );
  }
}
