//import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/card_with_AI_entity.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/custom_card.dart';
import 'package:smart_cards/Features/Revision/Presentation/Views/widgets/custom_cached_image.dart';

class FrontSide extends StatelessWidget {
  const FrontSide({super.key, required this.card});
  final AICardEntity card;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        children: [
          /* Image.memory(
            base64Decode(card.imageBase64),
            height: 300.h,
            fit: BoxFit.contain,
          ), */
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: CachedImage(
              imageUrl: card.image_url,
              height: 300.h,
              fit: BoxFit.contain,
            ),
          ),
          // Image.network(card.imageUrl, height: 300.h, fit: BoxFit.contain),
          SizedBox(height: 14.h),
          Text(
            card.definition,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
