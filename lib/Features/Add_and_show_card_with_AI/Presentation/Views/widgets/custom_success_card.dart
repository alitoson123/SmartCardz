import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/card_with_AI_entity.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/back_side.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/custom_card.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/front_side.dart';
import 'package:smart_cards/core/Functions/section_title.dart';
import 'package:smart_cards/generated/l10n.dart';

class CustomSuccessCard extends StatelessWidget {
  const CustomSuccessCard({
    super.key,
    required this.card,
    required this.textController,
    this.selectedCollectionId,
  });
  final CardWithAIEntity card;
  final TextEditingController textController;
  final String? selectedCollectionId;

  @override
  Widget build(BuildContext context) {
    return card.is_valid == 'true'
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16.h),
              buildSectionTitle(context, S.of(context).FrontSide),
              SizedBox(height: 16.h),
              FrontSide(card: card),
              SizedBox(height: 28.h),
              buildSectionTitle(context, S.of(context).BackSide),
              SizedBox(height: 16.h),
              BackSide(card: card),
              SizedBox(height: 40.h),
            ],
          )
        : Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: CustomCard(
              child: Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '"${card.word}"',
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                        TextSpan(text: '  '),
                      TextSpan(
                        text: 'is not valid, try to fix the spelling',
                        style: TextStyle(
                          fontSize: 19.sp,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
