import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_cards/core/utils/widgets/my_text_button.dart';
import 'package:smart_cards/core/navigator/routes.dart';

class TextButtonOfForgetPassword extends StatelessWidget {
  const TextButtonOfForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MyTextButton(
          myText: 'Forgot Password?',
          onPressed: () {
            context.push(AppRoutes.ForgetPasswordScreen);
          },
        ),
      ],
    );
  }
}
