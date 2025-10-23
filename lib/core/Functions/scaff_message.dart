import 'package:flutter/material.dart';

void showScaffMessage(
  BuildContext context,
  String message, {
  Color color = Colors.blueAccent,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: Duration(milliseconds: 1500),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
