import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/card_with_AI_entity.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/custom_card.dart';
import 'package:smart_cards/generated/l10n.dart';

class NotValidCard extends StatelessWidget {
  const NotValidCard({super.key, required this.card});

  final AICardEntity card;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                // this word is not valid try to fix the spelling
                TextSpan(
                  text: S.of(context).isNotValidTryToFixTheSpelling,
                  style: TextStyle(
                    fontSize: 19.sp,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
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
