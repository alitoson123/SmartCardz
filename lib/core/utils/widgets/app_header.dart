import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
  });
  final IconData icon;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.all(18.r),
          child: Icon(icon, size: 50.sp, color: Colors.blueAccent),
        ),
        SizedBox(height: 16.h),
        Text(title),
        SizedBox(height: 6.h),
        Text(subTitle, textAlign: TextAlign.center),
      ],
    );
  }
}
