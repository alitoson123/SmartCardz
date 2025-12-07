import 'dart:io';

import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.icon,
    required this.hint,
    this.maxLines = 1,
    this.onImageTap,
    this.imagePath,
    this.onImageCanel,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final IconData icon;
  final String hint;
  final int? maxLines;
  final void Function()? onImageTap;
  final File? imagePath;
  final void Function()? onImageCanel;
  final Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: theme.brightness == Brightness.light
                    ? Colors.grey.shade300
                    : Colors.black.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            onSubmitted: onSubmitted,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: theme.colorScheme.primary),
              suffixIcon: IconButton(
                icon: const Icon(Icons.image, color: Colors.blue),
                onPressed: onImageTap,
              ),
              hintText: hint,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
            ),
          ),
        ),

        if (imagePath != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(imagePath!, height: 120, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 0,
                  right: -8,
                  child: IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    onPressed: onImageCanel,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
