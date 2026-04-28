import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/generated/l10n.dart';

// 📁 widgets/row_of_difficulty_button.dart

class RowOfDifficultyButton extends StatelessWidget {
  final Function(int quality) onRating;

  const RowOfDifficultyButton({super.key, required this.onRating});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h, right: 16.w, left: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: _RatingBtn(
              label: S.of(context).again,
              quality: 0,
              color: Colors.red,
              onPressed: () => onRating(0),
            ),
          ),
          SizedBox(width: 8.w),

          /*   _RatingBtn(
            label: S.of(context).hard,
            quality: 1,
            color: Colors.orange,
            onPressed: () => onRating(1),
          ),*/
          Expanded(
            child: _RatingBtn(
              label: S.of(context).medium,
              quality: 3,
              color: Colors.orange,
              onPressed: () => onRating(3),
            ),
          ),
          SizedBox(width: 8.w),

          Expanded(
            child: _RatingBtn(
              label: S.of(context).easy,
              quality: 4,
              color: Colors.green,
              onPressed: () => onRating(4),
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingBtn extends StatelessWidget {
  final String label;
  final int quality;
  final Color color;
  final VoidCallback onPressed;

  const _RatingBtn({
    required this.label,
    required this.quality,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
