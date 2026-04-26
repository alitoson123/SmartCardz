import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/generated/l10n.dart';

class ReminderRepeatSwitch extends StatelessWidget {
  final bool repeatDaily;
  final ValueChanged<bool> onChanged;

  const ReminderRepeatSwitch({
    super.key,
    required this.repeatDaily,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final surfaceColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).repeatDaily,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  S.of(context).sameTimeEveryDay,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: textColor.withAlpha(160),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: repeatDaily,
            onChanged: onChanged,
            activeColor: primaryColor,
          ),
        ],
      ),
    );
  }
}
