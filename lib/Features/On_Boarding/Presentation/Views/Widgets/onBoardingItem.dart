import 'package:flutter/material.dart';
import 'package:smart_cards/Features/On_Boarding/Data/models/onboarding_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Onboardingitem extends StatelessWidget {
  const Onboardingitem({super.key, required this.onboardingModel});
  final OnboardingModel onboardingModel;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top area for image
        Align(
          alignment: Alignment.topCenter,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  onboardingModel.image,
                  width: 310.w,
                  height: 420.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        // Bottom white rounded container
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 190.h,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32.r),
                topRight: Radius.circular(32.r),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),
                Text(
                  onboardingModel.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.sp,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),

                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
