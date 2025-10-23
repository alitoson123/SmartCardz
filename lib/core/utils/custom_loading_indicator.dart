import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 50,
      width: 50,
      child: CircularProgressIndicator(
        strokeWidth: 5,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
      ),
    );
  }
}