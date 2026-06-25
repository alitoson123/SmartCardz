import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/card_with_AI_entity.dart';

class ShowAICardStates {}

class ShowAICardInitial extends ShowAICardStates {}

class ShowAICardLoading extends ShowAICardStates {}

class ShowAICardSuccess extends ShowAICardStates {
  final List<AICardEntity> card;

  ShowAICardSuccess({required this.card});
}

class ShowAICardFailure extends ShowAICardStates {
  final String errorMessage;

  ShowAICardFailure({required this.errorMessage});
}

class ShowAICardQuotaExceeded extends ShowAICardStates {
  final bool withImage;

  ShowAICardQuotaExceeded({required this.withImage});
}

class ShowAICardSuccessWithWarning extends ShowAICardStates {
  final List<AICardEntity> card;
  final int requestedCount;
  final int allowedCount;

  ShowAICardSuccessWithWarning({
    required this.card,
    required this.requestedCount,
    required this.allowedCount,
  });
}
