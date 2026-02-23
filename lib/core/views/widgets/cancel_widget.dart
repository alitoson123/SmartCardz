import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/generated/l10n.dart';

class CancelWidget extends StatelessWidget {
  const CancelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h, top: 8.h),
      child: TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(
          S.of(context).cancel,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.redAccent,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
