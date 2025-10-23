import 'package:smart_cards/core/Entities/base_card_entity.dart';

class FetchAndRatingStates {}

class FetchAndRatingInitial extends FetchAndRatingStates {}

class FetchAndRatingLoading extends FetchAndRatingStates {}

class FetchDueCardsSuccess extends FetchAndRatingStates {
  final List<BaseCardEntity> cards;

  FetchDueCardsSuccess({required this.cards});
}

class SubmitRatingSuccess extends FetchAndRatingStates {}

class FetchAndRatingFailure extends FetchAndRatingStates {
  final String errorMessage;

  FetchAndRatingFailure({required this.errorMessage});
}
