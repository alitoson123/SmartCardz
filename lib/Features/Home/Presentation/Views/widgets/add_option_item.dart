import 'package:flutter/material.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/label_of_options.dart';

class AddOptionItem extends StatelessWidget {
  const AddOptionItem({
    super.key,
    required this.label,
    required this.heroTag,
    required this.icon,
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.isRTL,
    required this.theme,
  });
  final String label;
  final String heroTag;
  final IconData icon;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool isRTL;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          LabelOfOptions(text: label, isRTL: isRTL, theme: theme),
          FloatingActionButton(
            shape: const CircleBorder(),
            heroTag: heroTag,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            onPressed: onPressed,
            child: Icon(icon),
          ),
        ],
      ),
    );
  }
}
