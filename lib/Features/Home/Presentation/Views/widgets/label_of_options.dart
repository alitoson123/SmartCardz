import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      margin: EdgeInsets.only(left: isRTL ? 12.w : 0, right: isRTL ? 0 : 12.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Text(text, style: theme.textTheme.bodyMedium),
    );
  }
}
