import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/generated/l10n.dart';

class TitleOfDialog extends StatelessWidget {
  const TitleOfDialog({super.key, required this.themeColors});

  final ColorScheme themeColors;

  @override
  Widget build(BuildContext context) {
    return Text(
      S.of(context).createCollectionTitle,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.sp,
        color: themeColors.onSurface,
      ),
    );
  }
}
