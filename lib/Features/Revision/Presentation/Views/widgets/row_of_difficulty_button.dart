import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Revision/Presentation/View_model/fetch_and_rating_cubit/fetch_and_rating_cubit.dart';
import 'package:smart_cards/Features/Revision/Presentation/Views/widgets/item_of_difficulty_button.dart';
import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';

class RowOfDifficultyButton extends StatelessWidget {
  const RowOfDifficultyButton({
    super.key,
    required this.card,
    required this.showAnswer,
    required this.currentIndex,
    required this.onNextCard,
  });

  final BaseCardEntity card;
  final bool showAnswer;
  final int currentIndex;
  final VoidCallback onNextCard;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ItemOfDifficultyButton(
          text: 'Easy',
          color: Colors.green,
          onPressed: () => submitRating(context, card, 5),
        ),
        ItemOfDifficultyButton(
          text: 'Medium',
          color: Colors.orange,
          onPressed: () => submitRating(context, card, 3),
        ),
        ItemOfDifficultyButton(
          text: 'Hard',
          color: Colors.red,
          onPressed: () => submitRating(context, card, 1),
        ),
      ],
    );
  }

  void submitRating(
    BuildContext context,
    BaseCardEntity card,
    int quality,
  ) async {
    final cubit = context.read<FetchAndRatingCubit>();
    await cubit.submitRating(card, quality,'');

    onNextCard(); // 👈 بعد ما يخلص التقييم، نروح للكارت اللي بعده
  }
}
