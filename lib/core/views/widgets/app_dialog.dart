// lib/core/widgets/app_dialog.dart

import 'package:flutter/material.dart';

enum DialogType { success, error, warning }

class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.type,
    required this.message,
    this.title,
    this.buttonText,
  });

  final DialogType type;
  final String message;
  final String? title;
  final String? buttonText;

  @override
  Widget build(BuildContext context) {
    final config = _getConfig();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon circle
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: config.iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(config.icon, color: config.color, size: 32),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              message.isNotEmpty ? message : config.defaultTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Message
            /*  Text(
              message,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
*/
            // Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: config.color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: Text(buttonText ?? 'Got it'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _DialogConfig _getConfig() {
    switch (type) {
      case DialogType.success:
        return _DialogConfig(
          icon: Icons.check_rounded,
          color: const Color(0xFF639922),
          iconBg: const Color(0xFFEAF3DE),
          defaultTitle: 'Success',
        );
      case DialogType.error:
        return _DialogConfig(
          icon: Icons.error_outline_rounded,
          color: const Color(0xFFE24B4A),
          iconBg: const Color(0xFFFCEBEB),
          defaultTitle: 'Something went wrong',
        );
      case DialogType.warning:
        return _DialogConfig(
          icon: Icons.warning_amber_rounded,
          color: const Color(0xFFBA7517),
          iconBg: const Color(0xFFFAEEDA),
          defaultTitle: 'Warning',
        );
    }
  }
}

class _DialogConfig {
  final IconData icon;
  final Color color;
  final Color iconBg;
  final String defaultTitle;
  const _DialogConfig({
    required this.icon,
    required this.color,
    required this.iconBg,
    required this.defaultTitle,
  });
}
