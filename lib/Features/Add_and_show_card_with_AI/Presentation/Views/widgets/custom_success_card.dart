import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/card_with_AI_entity.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/View_model/add_and_show_card_cubit/add_and_show_card_cubit.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/back_side.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/front_side.dart';
import 'package:smart_cards/core/Functions/section_title.dart';
import 'package:smart_cards/core/utils/widgets/app_button.dart';
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
    return Column(
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
    );
  }
}
