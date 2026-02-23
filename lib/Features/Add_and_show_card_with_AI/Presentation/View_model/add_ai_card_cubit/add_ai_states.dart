class AddAICardStates {}

class AddAICardInitial extends AddAICardStates {}

class AddAICardLoading extends AddAICardStates {}

class AddAICardSuccess extends AddAICardStates {}

class AddAICardFailure extends AddAICardStates {
  final String errorMessage;

  AddAICardFailure({required this.errorMessage});
}
