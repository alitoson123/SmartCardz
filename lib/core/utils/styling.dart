/*import 'package:care_now_flutter/core/utils/app_color.dart';
import 'package:care_now_flutter/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class Styling {
  static final font10black300 = TextStyle(
    color: AppColor.black,
    fontSize: 10.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font12black300 = TextStyle(
    color: AppColor.black,
    fontSize: 12.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font14black300 = TextStyle(
    color: AppColor.black,
    fontSize: 14.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font16black300 = TextStyle(
    color: AppColor.black,
    fontSize: 16.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font18black300 = TextStyle(
    color: AppColor.black,
    fontSize: 18.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font20black300 = TextStyle(
    color: AppColor.black,
    fontSize: 20.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font24black300 = TextStyle(
    color: AppColor.black,
    fontSize: 24.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font32black300 = TextStyle(
    color: AppColor.black,
    fontSize: 32.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font36black300 = TextStyle(
    color: AppColor.black,
    fontSize: 36.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font10black400 = TextStyle(
    color: AppColor.black,
    fontSize: 10.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font12black400 = TextStyle(
    color: AppColor.black,
    fontSize: 12.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font14black400 = TextStyle(
    color: AppColor.black,
    fontSize: 14.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font16black400 = TextStyle(
    color: AppColor.black,
    fontSize: 16.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font18black400 = TextStyle(
    color: AppColor.black,
    fontSize: 18.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font20black400 = TextStyle(
    color: AppColor.black,
    fontSize: 20.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font24black400 = TextStyle(
    color: AppColor.black,
    fontSize: 24.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font32black400 = TextStyle(
    color: AppColor.black,
    fontSize: 32.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font36black400 = TextStyle(
    color: AppColor.black,
    fontSize: 36.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font10black600 = TextStyle(
    color: AppColor.black,
    fontSize: 10.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font12black600 = TextStyle(
    color: AppColor.black,
    fontSize: 12.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font14black600 = TextStyle(
    color: AppColor.black,
    fontSize: 14.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font16black600 = TextStyle(
    color: AppColor.black,
    fontSize: 16.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font18black600 = TextStyle(
    color: AppColor.black,
    fontSize: 18.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font20black600 = TextStyle(
    color: AppColor.black,
    fontSize: 20.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font24black600 = TextStyle(
    color: AppColor.black,
    fontSize: 24.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font32black600 = TextStyle(
    color: AppColor.black,
    fontSize: 32.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font36black600 = TextStyle(
    color: AppColor.black,
    fontSize: 36.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font10black700 = TextStyle(
    color: AppColor.black,
    fontSize: 10.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font12black700 = TextStyle(
    color: AppColor.black,
    fontSize: 12.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font14black700 = TextStyle(
    color: AppColor.black,
    fontSize: 14.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font16black700 = TextStyle(
    color: AppColor.black,
    fontSize: 16.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font18black700 = TextStyle(
    color: AppColor.black,
    fontSize: 18.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font20black700 = TextStyle(
    color: AppColor.black,
    fontSize: 20.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font24black700 = TextStyle(
    color: AppColor.black,
    fontSize: 24.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font32black700 = TextStyle(
    color: AppColor.black,
    fontSize: 32.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font36black700 = TextStyle(
    color: AppColor.black,
    fontSize: 36.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font10white300 = TextStyle(
    color: AppColor.white,
    fontSize: 10.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font12white300 = TextStyle(
    color: AppColor.white,
    fontSize: 12.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font14white300 = TextStyle(
    color: AppColor.white,
    fontSize: 14.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font16white300 = TextStyle(
    color: AppColor.white,
    fontSize: 16.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font18white300 = TextStyle(
    color: AppColor.white,
    fontSize: 18.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font20white300 = TextStyle(
    color: AppColor.white,
    fontSize: 20.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font24white300 = TextStyle(
    color: AppColor.white,
    fontSize: 24.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font32white300 = TextStyle(
    color: AppColor.white,
    fontSize: 32.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font36white300 = TextStyle(
    color: AppColor.white,
    fontSize: 36.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font10white400 = TextStyle(
    color: AppColor.white,
    fontSize: 10.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font12white400 = TextStyle(
    color: AppColor.white,
    fontSize: 12.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font14white400 = TextStyle(
    color: AppColor.white,
    fontSize: 14.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font16white400 = TextStyle(
    color: AppColor.white,
    fontSize: 16.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font18white400 = TextStyle(
    color: AppColor.white,
    fontSize: 18.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font20white400 = TextStyle(
    color: AppColor.white,
    fontSize: 20.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font24white400 = TextStyle(
    color: AppColor.white,
    fontSize: 24.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font32white400 = TextStyle(
    color: AppColor.white,
    fontSize: 32.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font36white400 = TextStyle(
    color: AppColor.white,
    fontSize: 36.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font10white600 = TextStyle(
    color: AppColor.white,
    fontSize: 10.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font12white600 = TextStyle(
    color: AppColor.white,
    fontSize: 12.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font14white600 = TextStyle(
    color: AppColor.white,
    fontSize: 14.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font16white600 = TextStyle(
    color: AppColor.white,
    fontSize: 16.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font18white600 = TextStyle(
    color: AppColor.white,
    fontSize: 18.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font18white500 = TextStyle(
    color: AppColor.white,
    fontSize: 18.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w500,
  );
  static final font20white600 = TextStyle(
    color: AppColor.white,
    fontSize: 20.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font24white600 = TextStyle(
    color: AppColor.white,
    fontSize: 24.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font32white600 = TextStyle(
    color: AppColor.white,
    fontSize: 32.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font36white600 = TextStyle(
    color: AppColor.white,
    fontSize: 36.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font10white700 = TextStyle(
    color: AppColor.white,
    fontSize: 10.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font12white700 = TextStyle(
    color: AppColor.white,
    fontSize: 12.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font14white700 = TextStyle(
    color: AppColor.white,
    fontSize: 14.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font16white700 = TextStyle(
    color: AppColor.white,
    fontSize: 16.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font18white700 = TextStyle(
    color: AppColor.white,
    fontSize: 18.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font20white700 = TextStyle(
    color: AppColor.white,
    fontSize: 20.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font24white700 = TextStyle(
    color: AppColor.white,
    fontSize: 24.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font32white700 = TextStyle(
    color: AppColor.white,
    fontSize: 32.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font36white700 = TextStyle(
    color: AppColor.white,
    fontSize: 36.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  // وزن 300
  static final font10cyan300 = TextStyle(
    color: AppColor.cyan700,
    fontSize: 10.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font12cyan300 = TextStyle(
    color: AppColor.cyan700,
    fontSize: 12.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font14cyan300 = TextStyle(
    color: AppColor.cyan700,
    fontSize: 14.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font16cyan300 = TextStyle(
    color: AppColor.cyan700,
    fontSize: 16.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font18cyan300 = TextStyle(
    color: AppColor.cyan700,
    fontSize: 18.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font20cyan300 = TextStyle(
    color: AppColor.cyan700,
    fontSize: 20.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font24cyan300 = TextStyle(
    color: AppColor.cyan700,
    fontSize: 24.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font32cyan300 = TextStyle(
    color: AppColor.cyan700,
    fontSize: 32.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font36cyan300 = TextStyle(
    color: AppColor.cyan700,
    fontSize: 36.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );

  // وزن 400
  static final font10cyan400 = TextStyle(
    color: AppColor.cyan700,
    fontSize: 10.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font10cyan400Underline = TextStyle(
    decoration: TextDecoration.underline,
    decorationColor: AppColor.cyan700,
    decorationThickness: 1,
    color: AppColor.cyan700,
    fontSize: 10.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font12cyan400 = TextStyle(
    color: AppColor.cyan700,
    fontSize: 12.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font14cyan400 = TextStyle(
    color: AppColor.cyan700,
    fontSize: 14.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font16cyan400 = TextStyle(
    color: AppColor.cyan700,
    fontSize: 16.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font18cyan400 = TextStyle(
    color: AppColor.cyan700,
    fontSize: 18.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font20cyan400 = TextStyle(
    color: AppColor.cyan700,
    fontSize: 20.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font24cyan400 = TextStyle(
    color: AppColor.cyan700,
    fontSize: 24.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font32cyan400 = TextStyle(
    color: AppColor.cyan700,
    fontSize: 32.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font36cyan400 = TextStyle(
    color: AppColor.cyan700,
    fontSize: 36.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );

  // وزن 600
  static final font10cyan600UnderLine = TextStyle(
    decoration: TextDecoration.underline,
    decorationColor: AppColor.cyan700,
    decorationThickness: 1,
    color: AppColor.cyan700,
    fontSize: 10.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font10cyan600 = TextStyle(
    color: AppColor.cyan700,
    fontSize: 12.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font12cyan600 = TextStyle(
    color: AppColor.cyan700,
    fontSize: 12.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font14cyan600 = TextStyle(
    color: AppColor.cyan700,
    fontSize: 14.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font16cyan600 = TextStyle(
    color: AppColor.cyan700,
    fontSize: 16.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font18cyan600 = TextStyle(
    color: AppColor.cyan700,
    fontSize: 18.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font20cyan600 = TextStyle(
    color: AppColor.cyan700,
    fontSize: 20.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font24cyan600 = TextStyle(
    color: AppColor.cyan700,
    fontSize: 24.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font32cyan600 = TextStyle(
    color: AppColor.cyan700,
    fontSize: 32.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font36cyan600 = TextStyle(
    color: AppColor.cyan700,
    fontSize: 36.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );

  // وزن 700
  static final font10cyan700 = TextStyle(
    color: AppColor.cyan700,
    fontSize: 10.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font12cyan700 = TextStyle(
    color: AppColor.cyan700,
    fontSize: 12.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font14cyan700 = TextStyle(
    color: AppColor.cyan700,
    fontSize: 14.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font16cyan700 = TextStyle(
    color: AppColor.cyan700,
    fontSize: 16.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font18cyan700 = TextStyle(
    color: AppColor.cyan700,
    fontSize: 18.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font20cyan700 = TextStyle(
    color: AppColor.cyan700,
    fontSize: 20.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font24cyan700 = TextStyle(
    color: AppColor.cyan700,
    fontSize: 24.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font32cyan700 = TextStyle(
    color: AppColor.cyan700,
    fontSize: 32.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font36cyan700 = TextStyle(
    color: AppColor.cyan700,
    fontSize: 36.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font10grey300 = TextStyle(
    color: AppColor.grey600,
    fontSize: 10.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font12grey300 = TextStyle(
    color: AppColor.grey600,
    fontSize: 12.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font14grey300 = TextStyle(
    color: AppColor.grey600,
    fontSize: 14.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font16grey300 = TextStyle(
    color: AppColor.grey600,
    fontSize: 16.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font18grey300 = TextStyle(
    color: AppColor.grey600,
    fontSize: 18.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font20grey300 = TextStyle(
    color: AppColor.grey600,
    fontSize: 20.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font24grey300 = TextStyle(
    color: AppColor.grey600,
    fontSize: 24.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font32grey300 = TextStyle(
    color: AppColor.grey600,
    fontSize: 32.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font36grey300 = TextStyle(
    color: AppColor.grey600,
    fontSize: 36.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font10grey400 = TextStyle(
    color: AppColor.grey600,
    fontSize: 10.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font12grey400 = TextStyle(
    color: AppColor.grey600,
    fontSize: 12.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font14grey400 = TextStyle(
    color: AppColor.grey600,
    fontSize: 14.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font16grey400 = TextStyle(
    color: AppColor.grey600,
    fontSize: 16.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font18grey400 = TextStyle(
    color: AppColor.grey600,
    fontSize: 18.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font8grey400 = TextStyle(
    color: AppColor.grey600,
    fontSize: 8.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font20grey400 = TextStyle(
    color: AppColor.grey600,
    fontSize: 20.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font24grey400 = TextStyle(
    color: AppColor.grey600,
    fontSize: 24.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font32grey400 = TextStyle(
    color: AppColor.grey600,
    fontSize: 32.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font36grey400 = TextStyle(
    color: AppColor.grey600,
    fontSize: 36.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font10grey600 = TextStyle(
    color: AppColor.grey600,
    fontSize: 10.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font12grey600 = TextStyle(
    color: AppColor.grey600,
    fontSize: 12.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font14grey600 = TextStyle(
    color: AppColor.grey600,
    fontSize: 14.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font16grey600 = TextStyle(
    color: AppColor.grey600,
    fontSize: 16.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font18grey600 = TextStyle(
    color: AppColor.grey600,
    fontSize: 18.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font20grey600 = TextStyle(
    color: AppColor.grey600,
    fontSize: 20.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font24grey600 = TextStyle(
    color: AppColor.grey600,
    fontSize: 24.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font32grey600 = TextStyle(
    color: AppColor.grey600,
    fontSize: 32.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font36grey600 = TextStyle(
    color: AppColor.grey600,
    fontSize: 36.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font10grey700 = TextStyle(
    color: AppColor.grey600,
    fontSize: 10.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font12grey700 = TextStyle(
    color: AppColor.grey600,
    fontSize: 12.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font14grey700 = TextStyle(
    color: AppColor.grey600,
    fontSize: 14.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font16grey700 = TextStyle(
    color: AppColor.grey600,
    fontSize: 16.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font18grey700 = TextStyle(
    color: AppColor.grey600,
    fontSize: 18.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font20grey700 = TextStyle(
    color: AppColor.grey600,
    fontSize: 20.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font24grey700 = TextStyle(
    color: AppColor.grey600,
    fontSize: 24.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font32grey700 = TextStyle(
    color: AppColor.grey600,
    fontSize: 32.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font36grey700 = TextStyle(
    color: AppColor.grey600,
    fontSize: 36.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font10teal300 = TextStyle(
    color: AppColor.teal500,
    fontSize: 10.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font12teal300 = TextStyle(
    color: AppColor.teal500,
    fontSize: 12.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font14teal300 = TextStyle(
    color: AppColor.teal500,
    fontSize: 14.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font16teal300 = TextStyle(
    color: AppColor.teal500,
    fontSize: 16.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font18teal300 = TextStyle(
    color: AppColor.teal500,
    fontSize: 18.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font20teal300 = TextStyle(
    color: AppColor.teal500,
    fontSize: 20.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font24teal300 = TextStyle(
    color: AppColor.teal500,
    fontSize: 24.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font32teal300 = TextStyle(
    color: AppColor.teal500,
    fontSize: 32.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font36teal300 = TextStyle(
    color: AppColor.teal500,
    fontSize: 36.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font10teal400 = TextStyle(
    decoration: TextDecoration.underline,
    decorationColor: AppColor.teal500,
    decorationThickness: 1,
    color: AppColor.teal500,
    fontSize: 10.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font12teal400 = TextStyle(
    color: AppColor.teal500,
    fontSize: 12.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font14teal400 = TextStyle(
    color: AppColor.teal500,
    fontSize: 14.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font16teal400 = TextStyle(
    color: AppColor.teal500,
    fontSize: 16.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font18teal400 = TextStyle(
    color: AppColor.teal500,
    fontSize: 18.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font8teal400 = TextStyle(
    decoration: TextDecoration.underline,
    decorationColor: AppColor.teal500,
    decorationThickness: 1,
    color: AppColor.teal500,
    fontSize: 8.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font20teal400 = TextStyle(
    color: AppColor.teal500,
    fontSize: 20.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font24teal400 = TextStyle(
    color: AppColor.teal500,
    fontSize: 24.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font32teal400 = TextStyle(
    color: AppColor.teal500,
    fontSize: 32.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font36teal400 = TextStyle(
    color: AppColor.teal500,
    fontSize: 36.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font10teal600 = TextStyle(
    color: AppColor.teal500,
    fontSize: 10.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font12teal600 = TextStyle(
    color: AppColor.teal500,
    fontSize: 12.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font14teal500 = TextStyle(
    color: AppColor.teal500,
    fontSize: 14.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w500,
  );
  static final font14teal600 = TextStyle(
    color: AppColor.teal500,
    fontSize: 14.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font16teal600 = TextStyle(
    color: AppColor.teal500,
    fontSize: 16.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font18teal600 = TextStyle(
    color: AppColor.teal500,
    fontSize: 18.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font18teal500 = TextStyle(
    color: AppColor.teal500,
    fontSize: 18.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w500,
  );
  static final font20teal600 = TextStyle(
    color: AppColor.teal500,
    fontSize: 20.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font24teal600 = TextStyle(
    color: AppColor.teal500,
    fontSize: 24.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font32teal600 = TextStyle(
    color: AppColor.teal500,
    fontSize: 32.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font36teal600 = TextStyle(
    color: AppColor.teal500,
    fontSize: 36.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font10teal700 = TextStyle(
    color: AppColor.teal500,
    fontSize: 10.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font12teal700 = TextStyle(
    color: AppColor.teal500,
    fontSize: 12.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font14teal700 = TextStyle(
    color: AppColor.teal500,
    fontSize: 14.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font16teal700 = TextStyle(
    color: AppColor.teal500,
    fontSize: 16.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font18teal700 = TextStyle(
    color: AppColor.teal500,
    fontSize: 18.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font20teal700 = TextStyle(
    color: AppColor.teal500,
    fontSize: 20.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font24teal700 = TextStyle(
    color: AppColor.teal500,
    fontSize: 24.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font32teal700 = TextStyle(
    color: AppColor.teal500,
    fontSize: 32.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font36teal700 = TextStyle(
    color: AppColor.teal500,
    fontSize: 36.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font10cyan500_300 = TextStyle(
    color: AppColor.cyan500,
    fontSize: 10.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font12cyan500_300 = TextStyle(
    color: AppColor.cyan500,
    fontSize: 12.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font14cyan500_300 = TextStyle(
    color: AppColor.cyan500,
    fontSize: 14.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font16cyan500_300 = TextStyle(
    color: AppColor.cyan500,
    fontSize: 16.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font18cyan500_300 = TextStyle(
    color: AppColor.cyan500,
    fontSize: 18.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font20cyan500_300 = TextStyle(
    color: AppColor.cyan500,
    fontSize: 20.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font24cyan500_300 = TextStyle(
    color: AppColor.cyan500,
    fontSize: 24.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font32cyan500_300 = TextStyle(
    color: AppColor.cyan500,
    fontSize: 32.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font36cyan500_300 = TextStyle(
    color: AppColor.cyan500,
    fontSize: 36.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font10cyan500_400 = TextStyle(
    color: AppColor.cyan500,
    fontSize: 10.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font12cyan500_400 = TextStyle(
    color: AppColor.cyan500,
    fontSize: 12.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font14cyan500_400 = TextStyle(
    color: AppColor.cyan500,
    fontSize: 14.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font16cyan500_400 = TextStyle(
    color: AppColor.cyan500,
    fontSize: 16.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font18cyan500_400 = TextStyle(
    color: AppColor.cyan500,
    fontSize: 18.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font20cyan500_400 = TextStyle(
    color: AppColor.cyan500,
    fontSize: 20.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font24cyan500_400 = TextStyle(
    color: AppColor.cyan500,
    fontSize: 24.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font32cyan500_400 = TextStyle(
    color: AppColor.cyan500,
    fontSize: 32.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font36cyan500_400 = TextStyle(
    color: AppColor.cyan500,
    fontSize: 36.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font10cyan500_600 = TextStyle(
    color: AppColor.cyan500,
    fontSize: 10.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font12cyan500_600 = TextStyle(
    color: AppColor.cyan500,
    fontSize: 12.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font14cyan500_600 = TextStyle(
    color: AppColor.cyan500,
    fontSize: 14.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font16cyan500_600 = TextStyle(
    color: AppColor.cyan500,
    fontSize: 16.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font18cyan500_600 = TextStyle(
    color: AppColor.cyan500,
    fontSize: 18.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font20cyan500_600 = TextStyle(
    color: AppColor.cyan500,
    fontSize: 20.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font24cyan500_600 = TextStyle(
    color: AppColor.cyan500,
    fontSize: 24.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font32cyan500_600 = TextStyle(
    color: AppColor.cyan500,
    fontSize: 32.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font36cyan500_600 = TextStyle(
    color: AppColor.cyan500,
    fontSize: 36.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font10cyan500_700 = TextStyle(
    color: AppColor.cyan500,
    fontSize: 10.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font12cyan500_700 = TextStyle(
    color: AppColor.cyan500,
    fontSize: 12.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font14cyan500_700 = TextStyle(
    color: AppColor.cyan500,
    fontSize: 14.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font16cyan500_700 = TextStyle(
    color: AppColor.cyan500,
    fontSize: 16.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font18cyan500_700 = TextStyle(
    color: AppColor.cyan500,
    fontSize: 18.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font20cyan500_700 = TextStyle(
    color: AppColor.cyan500,
    fontSize: 20.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font24cyan500_700 = TextStyle(
    color: AppColor.cyan500,
    fontSize: 24.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font32cyan500_700 = TextStyle(
    color: AppColor.cyan500,
    fontSize: 32.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font36cyan500_700 = TextStyle(
    color: AppColor.cyan500,
    fontSize: 36.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font10lightCyan300 = TextStyle(
    color: AppColor.lightCyan800,
    fontSize: 10.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font12lightCyan300 = TextStyle(
    color: AppColor.lightCyan800,
    fontSize: 12.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font14lightCyan300 = TextStyle(
    color: AppColor.lightCyan800,
    fontSize: 14.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font16lightCyan300 = TextStyle(
    color: AppColor.lightCyan800,
    fontSize: 16.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font18lightCyan300 = TextStyle(
    color: AppColor.lightCyan800,
    fontSize: 18.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font20lightCyan300 = TextStyle(
    color: AppColor.lightCyan800,
    fontSize: 20.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font24lightCyan300 = TextStyle(
    color: AppColor.lightCyan800,
    fontSize: 24.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font32lightCyan300 = TextStyle(
    color: AppColor.lightCyan800,
    fontSize: 32.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font36lightCyan300 = TextStyle(
    color: AppColor.lightCyan800,
    fontSize: 36.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font10lightCyan400 = TextStyle(
    color: AppColor.lightCyan800,
    fontSize: 10.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font12lightCyan400 = TextStyle(
    color: AppColor.lightCyan800,
    fontSize: 12.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font14lightCyan400 = TextStyle(
    color: AppColor.lightCyan800,
    fontSize: 14.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font16lightCyan400 = TextStyle(
    color: AppColor.lightCyan800,
    fontSize: 16.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font18lightCyan400 = TextStyle(
    color: AppColor.lightCyan800,
    fontSize: 18.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font20lightCyan400 = TextStyle(
    color: AppColor.lightCyan800,
    fontSize: 20.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font24lightCyan400 = TextStyle(
    color: AppColor.lightCyan800,
    fontSize: 24.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font32lightCyan400 = TextStyle(
    color: AppColor.lightCyan800,
    fontSize: 32.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font36lightCyan400 = TextStyle(
    color: AppColor.lightCyan800,
    fontSize: 36.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font10lightCyan600 = TextStyle(
    color: AppColor.lightCyan800,
    fontSize: 10.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font12lightCyan600 = TextStyle(
    color: AppColor.lightCyan800,
    fontSize: 12.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font14lightCyan600 = TextStyle(
    color: AppColor.lightCyan800,
    fontSize: 14.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font16lightCyan600 = TextStyle(
    color: AppColor.lightCyan800,
    fontSize: 16.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font18lightCyan600 = TextStyle(
    color: AppColor.lightCyan800,
    fontSize: 18.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font20lightCyan600 = TextStyle(
    color: AppColor.lightCyan800,
    fontSize: 20.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font24lightCyan600 = TextStyle(
    color: AppColor.lightCyan800,
    fontSize: 24.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font32lightCyan600 = TextStyle(
    color: AppColor.lightCyan800,
    fontSize: 32.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font36lightCyan600 = TextStyle(
    color: AppColor.lightCyan800,
    fontSize: 36.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font10lightCyan700 = TextStyle(
    color: AppColor.lightCyan800,
    fontSize: 10.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font12lightCyan700 = TextStyle(
    color: AppColor.lightCyan800,
    fontSize: 12.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font14lightCyan700 = TextStyle(
    color: AppColor.lightCyan800,
    fontSize: 14.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font16lightCyan700 = TextStyle(
    color: AppColor.lightCyan800,
    fontSize: 16.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font18lightCyan700 = TextStyle(
    color: AppColor.lightCyan800,
    fontSize: 18.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font20lightCyan700 = TextStyle(
    color: AppColor.lightCyan800,
    fontSize: 20.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font24lightCyan700 = TextStyle(
    color: AppColor.lightCyan800,
    fontSize: 24.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font32lightCyan700 = TextStyle(
    color: AppColor.lightCyan800,
    fontSize: 32.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font36lightCyan700 = TextStyle(
    color: AppColor.lightCyan800,
    fontSize: 36.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font10green300 = TextStyle(
    color: AppColor.green400,
    fontSize: 10.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font12green300 = TextStyle(
    color: AppColor.green400,
    fontSize: 12.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font14green300 = TextStyle(
    color: AppColor.green400,
    fontSize: 14.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font16green300 = TextStyle(
    color: AppColor.green400,
    fontSize: 16.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font18green300 = TextStyle(
    color: AppColor.green400,
    fontSize: 18.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font20green300 = TextStyle(
    color: AppColor.green400,
    fontSize: 20.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font24green300 = TextStyle(
    color: AppColor.green400,
    fontSize: 24.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font32green300 = TextStyle(
    color: AppColor.green400,
    fontSize: 32.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font36green300 = TextStyle(
    color: AppColor.green400,
    fontSize: 36.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font10green400 = TextStyle(
    color: AppColor.green400,
    fontSize: 10.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font12green400 = TextStyle(
    color: AppColor.green400,
    fontSize: 12.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font14green400 = TextStyle(
    color: AppColor.green400,
    fontSize: 14.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font16green400 = TextStyle(
    color: AppColor.green400,
    fontSize: 16.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font18green400 = TextStyle(
    color: AppColor.green400,
    fontSize: 18.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font20green400 = TextStyle(
    color: AppColor.green400,
    fontSize: 20.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font24green400 = TextStyle(
    color: AppColor.green400,
    fontSize: 24.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font32green400 = TextStyle(
    color: AppColor.green400,
    fontSize: 32.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font36green400 = TextStyle(
    color: AppColor.green400,
    fontSize: 36.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font10green600 = TextStyle(
    color: AppColor.green400,
    fontSize: 10.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font12green600 = TextStyle(
    color: AppColor.green400,
    fontSize: 12.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font14green600 = TextStyle(
    color: AppColor.green400,
    fontSize: 14.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font16green600 = TextStyle(
    color: AppColor.green400,
    fontSize: 16.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font18green600 = TextStyle(
    color: AppColor.green400,
    fontSize: 18.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font20green600 = TextStyle(
    color: AppColor.green400,
    fontSize: 20.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font24green600 = TextStyle(
    color: AppColor.green400,
    fontSize: 24.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font32green600 = TextStyle(
    color: AppColor.green400,
    fontSize: 32.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font36green600 = TextStyle(
    color: AppColor.green400,
    fontSize: 36.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w600,
  );
  static final font10green700 = TextStyle(
    color: AppColor.green400,
    fontSize: 10.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font12green700 = TextStyle(
    color: AppColor.green400,
    fontSize: 12.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font14green700 = TextStyle(
    color: AppColor.green400,
    fontSize: 14.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font16green700 = TextStyle(
    color: AppColor.green400,
    fontSize: 16.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font18green700 = TextStyle(
    color: AppColor.green400,
    fontSize: 18.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font20green700 = TextStyle(
    color: AppColor.green400,
    fontSize: 20.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font24green700 = TextStyle(
    color: AppColor.green400,
    fontSize: 24.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font32green700 = TextStyle(
    color: AppColor.green400,
    fontSize: 32.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font36green700 = TextStyle(
    color: AppColor.green400,
    fontSize: 36.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w700,
  );
  static final font18red500 = TextStyle(
    color: AppColor.red500,
    fontSize: 18.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w500,
  );

  static final hintText14 = TextStyle(
    fontFamily: AppConstant.kFontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w300,
    color: AppColor.hintColor,
  );
  static final hintText12 = TextStyle(
    fontFamily: AppConstant.kFontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w300,
    color: AppColor.hintColor,
  );
  static final font10teal500 = TextStyle(
    color: AppColor.teal500,
    fontSize: 10.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w500,
  );
  static final font10black500 = TextStyle(
    color: AppColor.black,
    fontSize: 10.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w500,
  );
  static final font16blue900 = TextStyle(
    color: AppColor.blue900,
    fontSize: 16.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w500,
  );
  static final font16blue400 = TextStyle(
    color: AppColor.blue900,
    fontSize: 16.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font14Grey44500 = TextStyle(
    color: AppColor.Grey44,
    fontSize: 14.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w500,
  );
  static final font12GreyA300 = TextStyle(
    color: AppColor.GreyA,
    fontSize: 12.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w300,
  );
  static final font14cyan400400 = TextStyle(
    color: AppColor.cyan400,
    fontSize: 14.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );

  static final font8cyan400 = TextStyle(
    color: AppColor.cyan600,
    fontSize: 8.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font6grey400 = TextStyle(
    color: AppColor.grey600,
    fontSize: 6.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
  static final font8cyan400Underlined = TextStyle(
    color: AppColor.cyan600,
    fontSize: 8.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.underline,
  );
  static final font14red400 = TextStyle(
    color: AppColor.red200,
    fontSize: 14.sp,
    fontFamily: AppConstant.kFontFamily,
    fontWeight: FontWeight.w400,
  );
}
*/