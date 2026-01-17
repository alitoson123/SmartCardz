import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/custom_card.dart';
import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';

class BackSide extends StatelessWidget {
  const BackSide({super.key, required this.card});
  final BaseCardEntity card;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: card.word,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const TextSpan(text: '  '),
                TextSpan(
                  text: '(${card.type})',
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          Divider(color: Colors.grey.shade300),
          if (card.example.isNotEmpty && card.example[0].isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                '"${card.example[0]}"',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          if (card.example.length > 1 && card.example[1].isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                '"${card.example[1]}"',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}
