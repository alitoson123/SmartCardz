import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/core/utils/widgets/custom_loading_indicator.dart';
import 'package:smart_cards/generated/l10n.dart';

class AICardLoadingIndicator extends StatelessWidget {
  const AICardLoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomLoadingIndicator(),
        SizedBox(height: 12.h),
        Material(
          color: Colors.transparent,
          child: Text(
            S.of(context).generatingYourSmartCard,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}