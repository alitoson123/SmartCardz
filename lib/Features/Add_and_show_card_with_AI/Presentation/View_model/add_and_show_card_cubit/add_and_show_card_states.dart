import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/card_with_AI_entity.dart';

class AddAndShowCardStates {}

class AddAndShowCardInitial extends AddAndShowCardStates {}

class AddAndShowCardLoading extends AddAndShowCardStates {}

class ShowCardSuccess extends AddAndShowCardStates {
  final List<CardWithAIEntity> card;

  ShowCardSuccess({required this.card});
}

class AddCardSuccess extends AddAndShowCardStates {}

class AddAndShowCardFailure extends AddAndShowCardStates {
  final String errorMessage;

  AddAndShowCardFailure({required this.errorMessage});
}

class RequestAISuccess extends AddAndShowCardStates {}
