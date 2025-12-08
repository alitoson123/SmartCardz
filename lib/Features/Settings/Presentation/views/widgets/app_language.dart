import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/generated/l10n.dart';

class AppLanguage extends StatefulWidget {
  final String initialLanguage;

  const AppLanguage({super.key, required this.initialLanguage});

  @override
  State<AppLanguage> createState() => _AppThemeState();
}

class _AppThemeState extends State<AppLanguage> {
  String? language;

  @override
  void initState() {
    super.initState();
    language = widget.initialLanguage;
  }

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).colorScheme;

    return AlertDialog(
      backgroundColor: themeColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      title: Text(
        S.of(context).appLanguage,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: themeColors.onSurface,
        ),
      ),

      content: Container(
        decoration: BoxDecoration(
          color: themeColors.surface,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(
              activeColor: Colors.blueAccent,
              title: Text(
                'English',
                style: TextStyle(color: themeColors.onSurface),
              ),
              value: 'en',
              groupValue: language,
              onChanged: (val) => setState(() => language = val),
            ),
            RadioListTile(
              activeColor: Colors.blueAccent,
              title: Text(
                'العربية',
                style: TextStyle(color: themeColors.onSurface),
              ),
              value: 'ar',
              groupValue: language,
              onChanged: (val) => setState(() => language = val),
            ),
          ],
        ),
      ),

      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            S.of(context).cancel,
            style: TextStyle(color: themeColors.primary),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, language),
          child: Text(
            S.of(context).save,
            style: TextStyle(color: themeColors.primary),
          ),
        ),
      ],
    );
  }
}
