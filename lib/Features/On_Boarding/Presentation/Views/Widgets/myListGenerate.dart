import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Mylistgenerate extends StatelessWidget {
  const Mylistgenerate({super.key, required this.currentIndex});
  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...List.generate(
          3,
          (index) => Padding(
            padding: EdgeInsets.all(2.r),
            child: Container(
              width: index == currentIndex ? 20.w : 6.w,
              height: 6.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.r),
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
