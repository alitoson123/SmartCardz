import 'package:flutter/material.dart';

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
    theme = widget.initialTheme; // ← جَبنا الثيم المختار مسبقًا
  }

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).colorScheme;

    return AlertDialog(
      backgroundColor: themeColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'App Theme',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: themeColors.onSurface,
        ),
      ),

      content: Container(
        decoration: BoxDecoration(
          color:  themeColors.surface ,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(
              activeColor: Colors.blueAccent,
              title: Text('Light', style: TextStyle(color: themeColors.onSurface)),
              value: 'Light',
              groupValue: theme,
              onChanged: (val) => setState(() => theme = val),
            ),
            RadioListTile(
              activeColor: Colors.blueAccent,
              title: Text('Dark', style: TextStyle(color: themeColors.onSurface)),
              value: 'Dark',
              groupValue: theme,
              onChanged: (val) => setState(() => theme = val),
            ),
          ],
        ),
      ),

      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(color: themeColors.primary)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, theme),
          child: Text('Save', style: TextStyle(color: themeColors.primary)),
        ),
      ],
    );
  }
}
