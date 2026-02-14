import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/generated/l10n.dart';

class noCollectionWidget extends StatelessWidget {
  const noCollectionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_copy, size: 64.sp, color: Colors.grey),
          SizedBox(height: 16.h),
          Text(
            S.of(context).NoCollectionsFound,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

