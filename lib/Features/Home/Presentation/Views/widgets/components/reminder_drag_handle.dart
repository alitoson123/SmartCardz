import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReminderDragHandle extends StatelessWidget {
  const ReminderDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Center(
        child: Container(
          width: 40.w,
          height: 4.h,
          decoration: BoxDecoration(
            color: textColor.withAlpha(60),
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
      ),
    );
  }
}
