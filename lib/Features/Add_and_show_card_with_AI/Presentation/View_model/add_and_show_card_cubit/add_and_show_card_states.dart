import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/card_with_AI_entity.dart';

class AddAndShowCardStates {}

class AddAndShowCardInitial extends AddAndShowCardStates {}

class ShowCardLoading extends AddAndShowCardStates {}

class AddCardLoading extends AddAndShowCardStates {}

class ShowCardSuccess extends AddAndShowCardStates {
  final List<CardWithAIEntity> card;

  ShowCardSuccess({required this.card});
}

class AddCardSuccess extends AddAndShowCardStates {}

class ShowCardFailure extends AddAndShowCardStates {
  final String errorMessage;

  ShowCardFailure({required this.errorMessage});
}

class AddCardFailure extends AddAndShowCardStates {
  final String errorMessage;

  AddCardFailure({required this.errorMessage});
}