import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/generated/l10n.dart';

class ReminderPreviewCard extends StatelessWidget {
  final String title;
  final String message;

  const ReminderPreviewCard({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final surfaceColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;

    final displayTitle = title.trim().isEmpty
        ? S.of(context).timeToStudy
        : title;
    final displayMessage = message.trim().isEmpty
        ? S.of(context).yourCardsAreWaitingKeepYourStreakAlive
        : message;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: primaryColor.withAlpha(60), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).preview,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              color: primaryColor,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            displayTitle,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            displayMessage,
            style: TextStyle(fontSize: 12.sp, color: textColor.withAlpha(180)),
          ),
        ],
      ),
    );
  }
}
