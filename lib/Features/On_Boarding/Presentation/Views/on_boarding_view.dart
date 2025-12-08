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
      body: SafeArea(
        child: Column(
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
            Mylistgenerate(currentIndex: currentIndex),
            SizedBox(height: 20.h),
            AppButton(
              onPressed: () {
                helper().goToNextPageMethod(
                  context: context,
                  currentIndex: currentIndex,
                  pageController: pageController,
                );
              },
              text: '',
              icon: Icons.arrow_forward,
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
