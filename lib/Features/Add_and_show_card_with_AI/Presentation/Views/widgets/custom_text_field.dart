import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: theme.brightness == Brightness.light
                  ? Colors.grey.shade200
                  : Colors.white10,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.brightness == Brightness.light
                    ? Colors.grey.shade300
                    : Colors.black.withOpacity(0.4),
                blurRadius: 8.r,
                offset: Offset(0, 3.h),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            onSubmitted: onSubmitted,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: theme.colorScheme.primary),
              suffixIcon: onImageTap != null
                  ? IconButton(
                      icon: const Icon(Icons.image, color: Colors.blue),
                      onPressed: onImageTap,
                    )
                  : null,
              hintText: hint,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 15.h,
              ),
            ),
          ),
        ),

        if (imagePath != null)
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.file(
                    imagePath!,
                    height: 120.h,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 0,
                  right: -8.w,
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
