import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_cards/core/navigator/routes.dart';

class helper {
  Future<void> goToNextPageMethod({
    required BuildContext context,
    required int currentIndex,
    required PageController pageController,
  }) async {
    if (currentIndex != 2) {
      pageController.animateToPage(
        currentIndex + 1,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      context.go(AppRoutes.signInScreen);
    }
  }
}
