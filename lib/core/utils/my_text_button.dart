import 'package:flutter/material.dart';

class MyTextButton extends StatelessWidget {
  const MyTextButton({
    super.key,
    required this.myText,
    required this.onPressed,
  });
  final String myText;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        myText,
        style: TextStyle(
          decoration: TextDecoration.underline,
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}
