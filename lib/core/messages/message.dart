import 'package:flutter/material.dart';
import 'package:smart_cards/core/views/widgets/app_dialog.dart';

class Message {
  void MessageErrorMethod(BuildContext context, {required String message}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          ),
        );
      },
    );
  }

  void showAppDialog({
    required BuildContext context,
    required DialogType type,
    required String message,
    String? title,
    String? buttonText,
  }) {
    showDialog(
      context: context,
      builder: (_) => AppDialog(
        type: type,
        message: message,
        title: title,
        buttonText: buttonText,
      ),
    );
  }

  void MessageSuccessMethod(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ),
    );
  }
}
