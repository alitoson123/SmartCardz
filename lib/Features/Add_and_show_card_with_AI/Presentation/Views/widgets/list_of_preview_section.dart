import 'package:flutter/material.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/card_with_AI_entity.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/custom_success_card.dart';



class ListOfPreviewSection extends StatelessWidget {
  const ListOfPreviewSection({
    super.key,
    required this.fadeAnimation,
    required this.textController,
    required this.selectedCollectionId, required this.card,
  });

  final Animation<double> fadeAnimation;
  final TextEditingController textController;
  final String? selectedCollectionId;
  final List<CardWithAIEntity> card;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: card.length,
      itemBuilder: (context, index) {
        return FadeTransition(
          opacity: fadeAnimation,
          child: CustomSuccessCard(
            card: card[index],
            selectedCollectionId: selectedCollectionId,
          ),
        );
      },
    );
  }
}
