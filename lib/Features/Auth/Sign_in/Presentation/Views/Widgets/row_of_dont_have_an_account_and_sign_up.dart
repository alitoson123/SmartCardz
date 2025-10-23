import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_cards/constant.dart';
import 'package:smart_cards/core/utils/routes.dart';

class RowOfDontHaveAnAccountAndSignUp extends StatelessWidget {
  const RowOfDontHaveAnAccountAndSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Don\'t have an account? ', style: Style().textStyle16),
        GestureDetector(
          onTap: () {
            context.push(AppRoutes.SignUpPage);
          },
          child: Text(
            'Sign Up',
            style: Style().textStyle16.copyWith(color: KPrimaryColor),
          ),
        ),
      ],
    );
  }
}
