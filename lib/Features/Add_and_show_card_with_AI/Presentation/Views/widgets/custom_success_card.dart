import 'package:flutter/material.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/card_with_AI_entity.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/not_valid_card.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/valid_card.dart';

class CustomSuccessCard extends StatelessWidget {
  const CustomSuccessCard({
    super.key,
    required this.card,
    this.selectedCollectionId,
  });
  final CardWithAIEntity card;
  final String? selectedCollectionId;

  @override
  Widget build(BuildContext context) {
    return card.is_valid == true
        ? ValidCard(card: card)
        : NotValidCard(card: card);
  }
}
