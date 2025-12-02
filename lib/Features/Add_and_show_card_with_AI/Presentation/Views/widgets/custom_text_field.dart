import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.onSubmitted,
    required this.controller,
    required this.icon,
    required this.hint,
    this.maxLines = 1,
  });

  final void Function(String)? onSubmitted;
  final TextEditingController controller;
  final IconData icon;
  final String hint;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor, // يأخذ من الثيم
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.light
                ? Colors.grey.shade300
                : Colors.black.withOpacity(0.4), // ظل مناسب للدارك
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(
          color: theme.textTheme.bodyLarge!.color, // لون النص من الثيم
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: theme.colorScheme.primary, // لون الأيقونة من الثيم
          ),
          hintText: hint,
          hintStyle: TextStyle(
            color: theme.hintColor, // يعتمد على الثيم
            fontSize: 16,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
        ),
        onSubmitted: onSubmitted,
      ),
    );
  }
}
