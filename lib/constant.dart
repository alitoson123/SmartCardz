import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/generated/l10n.dart';

const Color K_PRIMARY_COLOR = Color(0xff1E88E5);
const String K_USER_BOX = 'userBox';
const String K_COLLECTION_BOX = 'collectionBox';
const String K_Normar_Cards_BOX = 'normalCard';
const String K_AI_Cards_BOX = 'AICard';
const String K_DUE_CARDS_BOX = 'dueCard';
const String K_IS_LOGIN = 'isLogin';
const String K_CURRENT_USER = 'currentUser';
const String K_APP_THEME = 'appTheme';
const String K_APP_LANGUAGE = 'appLanguage';
const String K_PENDING_RATINGS_BOX = 'pending_ratings_box';
const String K_APP_VERSION = '2.1.0';
const String K_Stats_Prefix = 'collection_stats_';

class Style {
  TextStyle textStyle14 = TextStyle(fontSize: 14.sp);
  TextStyle textStyle16 = TextStyle(fontSize: 16.sp);
  TextStyle textStyle18 = TextStyle(fontSize: 18.sp);
  TextStyle textStyle20 = TextStyle(fontSize: 20.sp);
  TextStyle textStyle22 = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  TextStyle textStyle24 = TextStyle(fontSize: 24.sp);

  TextStyle textStyle28 = TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.bold,
    fontFamily: 'Mulish',
  );
}

class WhiteboardColors {
  // list of colors
  static const List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.black,
    Colors.white,
  ];

  // get color name
  static String getColorName(BuildContext context, Color color) {
    if (color == Colors.red) return S.of(context).red;
    if (color == Colors.blue) return S.of(context).blue;
    if (color == Colors.green) return S.of(context).green;
    if (color == Colors.yellow) return S.of(context).yellow;
    if (color == Colors.orange) return S.of(context).orange;
    if (color == Colors.purple) return S.of(context).purple;
    if (color == Colors.pink) return S.of(context).pink;
    if (color == Colors.black) return S.of(context).black;
    if (color == Colors.white) return S.of(context).white;
    return S.of(context).color;
  }
}
