import 'package:flutter/material.dart';
import 'package:smart_cards/Features/On_Boarding/Data/models/onboarding_model.dart';
import 'package:smart_cards/Features/On_Boarding/Presentation/Views/Widgets/onBoardingItem.dart';

class Onbboardingbody extends StatefulWidget {
  const Onbboardingbody({
    super.key,
    required this.myOnPageChanged,
    required this.controller,
  });
  final Function(int) myOnPageChanged;
  final PageController controller;
  @override
  State<Onbboardingbody> createState() => _OnbboardingbodyState();
}

class _OnbboardingbodyState extends State<Onbboardingbody> {
  final List<OnboardingModel> onboardingModelsList = [
    OnboardingModel(
      description:
          'Master any subject with spaced repetition and active recall - the scientifically proven way to remember better.',
      image: 'assets/images/onboarding_spaced_repetition.png',
    ),
    OnboardingModel(
      description:
          'Paste words in any language and let AI create complete flashcards with images, definitions, word types, and examples.',
      image: 'assets/images/onboarding_ai_cards.png',
    ),
    OnboardingModel(
      description:
          'Organize your cards into collections, track your progress, and achieve your learning goals faster.',
      image: 'assets/images/onboarding_card_organization.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: widget.controller,
      onPageChanged: widget.myOnPageChanged,
      itemCount: onboardingModelsList.length,
      itemBuilder: (context, index) {
        return Onboardingitem(onboardingModel: onboardingModelsList[index]);
      },
    );
  }
}
