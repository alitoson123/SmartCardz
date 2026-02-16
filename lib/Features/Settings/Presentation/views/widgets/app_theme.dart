import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/generated/l10n.dart';

class AppTheme extends StatefulWidget {
  final String initialTheme;

  const AppTheme({super.key, required this.initialTheme});

  @override
  State<AppTheme> createState() => _AppThemeState();
}

class _AppThemeState extends State<AppTheme> {
  String? theme;

  @override
  void initState() {
    super.initState();
    theme = widget.initialTheme;
  }

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).colorScheme;

    return AlertDialog(
      backgroundColor: themeColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      title: Text(
        S.of(context).appTheme,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14.sp,
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
            // Light theme
            RadioListTile(
              activeColor: Colors.blueAccent,
              title: Text(
                S.of(context).light,
                style: TextStyle(color: themeColors.onSurface),
              ),
              value: S.of(context).light,
              groupValue: theme,
              onChanged: (val) => setState(() => theme = val),
            ),
            // Dark theme
            RadioListTile(
              activeColor: Colors.blueAccent,
              title: Text(
                S.of(context).dark,
                style: TextStyle(color: themeColors.onSurface),
              ),
              value: S.of(context).dark,
              groupValue: theme,
              onChanged: (val) => setState(() => theme = val),
            ),
          ],
        ),
      ),

      actions: [
        // Cancel button
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            S.of(context).cancel,
            style: TextStyle(color: themeColors.primary),
          ),
        ),
        // Save button
        TextButton(
          onPressed: () => Navigator.pop(context, theme),
          child: Text(
            S.of(context).save,
            style: TextStyle(color: themeColors.primary),
          ),
        ),
      ],
    );
  }
}
