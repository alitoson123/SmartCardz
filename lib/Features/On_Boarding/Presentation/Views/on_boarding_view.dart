import 'package:flutter/material.dart';
import 'package:smart_cards/Features/On_Boarding/Presentation/Views/Widgets/goToNextPageWithCheckLoginStatus.dart';
import 'package:smart_cards/Features/On_Boarding/Presentation/Views/Widgets/myListGenerate.dart';
import 'package:smart_cards/Features/On_Boarding/Presentation/Views/Widgets/onBboardingBody.dart';
import 'package:smart_cards/core/utils/widgets/app_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});
  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  int currentIndex = 0;
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE6F2FF),
      body: Column(
        children: [
          Expanded(
            child: Onbboardingbody(
              myOnPageChanged: (value) {
                setState(() {
                  currentIndex = value;
                });
              },
              controller: pageController,
            ),
          ),
          Container(
            color: Colors.white,
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  Mylistgenerate(currentIndex: currentIndex),
                  SizedBox(height: 24.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: AppButton(
                      onPressed: () {
                        helper().goToNextPageMethod(
                          context: context,
                          currentIndex: currentIndex,
                          pageController: pageController,
                        );
                      },
                      text: 'Continue',
                      icon: Icons.arrow_forward,
                    ),
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
