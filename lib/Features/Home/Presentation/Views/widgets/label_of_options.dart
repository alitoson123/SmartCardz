import 'package:flutter/material.dart';

class LabelOfOptions extends StatelessWidget {
  const LabelOfOptions({
    super.key,
    required this.text,
    required this.isRTL,
    required this.theme,
  });
  final String text;
  final bool isRTL;
  final ThemeData theme;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: isRTL ? 12 : 0, right: isRTL ? 0 : 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(text, style: theme.textTheme.bodyMedium),
    );
  }
}
