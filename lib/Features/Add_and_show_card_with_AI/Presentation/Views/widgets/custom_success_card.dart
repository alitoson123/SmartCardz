import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/card_with_AI_entity.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/View_model/add_and_show_card_cubit/add_and_show_card_cubit.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/back_side.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/front_side.dart';
import 'package:smart_cards/core/Functions/section_title.dart';
import 'package:smart_cards/core/utils/app_button.dart';

class CustomSuccessCard extends StatelessWidget {
  const CustomSuccessCard({
    super.key,
    required this.card,
    required this.textController,
  });
  final CardWithAIEntity card;
  final TextEditingController textController;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 16.h),
        buildSectionTitle(context, 'Front Side'),
        SizedBox(height: 16.h),
        FrontSide(card: card),
        SizedBox(height: 28.h),
        buildSectionTitle(context, 'Back Side'),
        SizedBox(height: 16.h),
        BackSide(card: card),
        SizedBox(height: 40.h),
        AppButton(
          text: 'Add Card',
          onPressed: () {
            context.read<AddAndShowCardCubit>().addCard(
              word: card.word,
              definition: card.definition,
              example: card.example,
              type: card.type,
              imageBase64: 'card.imageBase64',
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Card saved successfully!'),
                backgroundColor: Colors.blueAccent,
                duration: Duration(milliseconds: 1500),
                behavior: SnackBarBehavior.floating,
              ),
            );
            textController.clear();
          },
          icon: Icons.add,
        ),
      ],
    );
  }
}
