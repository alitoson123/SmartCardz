import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectTheLanguageItem extends StatelessWidget {
  const SelectTheLanguageItem({super.key, required this.language, this.onTap});

  final Map<String, String> language;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: theme.primaryColor.withOpacity(0.1),
              radius: 20.r,
              child: Text(
                language['code']!.split('-').first.toUpperCase(),
                style: TextStyle(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  language['name']!,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                if (language['name'] != language['nativeName'])
                  Text(
                    language['nativeName']!,
                    style: TextStyle(fontSize: 12.sp, color: theme.hintColor),
                  ),
              ],
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16.sp,
              color: theme.hintColor,
            ),
          ],
        ),
      ),
    );
  }
}
