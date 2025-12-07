import 'package:flutter/material.dart';
import 'package:smart_cards/Features/On_Boarding/Data/models/onboarding_model.dart';

class Onboardingitem extends StatelessWidget {
  const Onboardingitem({super.key, required this.onboardingModel});
  final OnboardingModel onboardingModel;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'SmartCardz',
          style: TextStyle(
            color: Color(0xff1E88E5),
            fontSize: 50,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 40),
        Image.asset(onboardingModel.image, height: 300, fit: BoxFit.contain),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            onboardingModel.description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
        ),
      ],
    );
  }
}
