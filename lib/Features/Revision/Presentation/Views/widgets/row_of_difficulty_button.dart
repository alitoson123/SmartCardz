import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Revision/Presentation/View_model/fetch_and_rating_cubit/fetch_and_rating_cubit.dart';
import 'package:smart_cards/Features/Revision/Presentation/Views/widgets/item_of_difficulty_button.dart';
import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';
import 'package:smart_cards/generated/l10n.dart';

class RowOfDifficultyButton extends StatelessWidget {
  const RowOfDifficultyButton({
    super.key,
    required this.card,
    required this.showAnswer,
    required this.currentIndex,
    required this.onNextCard,
    required this.collectionId,
  });

  final BaseCardEntity card;
  final bool showAnswer;
  final int currentIndex;
  final VoidCallback onNextCard;
  final String collectionId;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ItemOfDifficultyButton(
          text: S.of(context).easy,
          color: Colors.green,
          onPressed: () => submitRating(context, card, 5),
        ),
        ItemOfDifficultyButton(
          text: S.of(context).medium,
          color: Colors.blue,
          onPressed: () => submitRating(context, card, 3),
        ),
        ItemOfDifficultyButton(
          text: S.of(context).hard,
          color: Colors.orange,
          onPressed: () => submitRating(context, card, 1),
        ),
        ItemOfDifficultyButton(
          text: S.of(context).again,
          color: Colors.red,
          onPressed: () => submitRating(context, card, 0),
        ),
      ],
    );
  }

  void submitRating(BuildContext context, BaseCardEntity card, int quality) {
    final cubit = context.read<FetchAndRatingCubit>();
    cubit.submitRating(card, quality, collectionId);

    onNextCard(); // 👈 تروح للكارت اللي بعده فوراً
  }
}
