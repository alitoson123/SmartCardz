import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/generated/l10n.dart';

class ActiveReminderBanner extends StatelessWidget {
  final int hour;
  final String period;
  final VoidCallback onCancel;

  const ActiveReminderBanner({
    super.key,
    required this.hour,
    required this.period,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: primaryColor.withAlpha(20),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: primaryColor.withAlpha(60)),
      ),
      child: Row(
        children: [
          Icon(Icons.notifications_active, color: primaryColor, size: 20.r),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              S.of(context).youHaveAnActiveReminderSetAt('$hour:00 $period'),
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
          GestureDetector(
            onTap: onCancel,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.redAccent.withAlpha(20),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                S.of(context).cancel,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
