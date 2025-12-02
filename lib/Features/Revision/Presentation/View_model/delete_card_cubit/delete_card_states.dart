class DeleteCardStates {}

class DeleteCardInitial extends DeleteCardStates {}

class DeleteCardLoading extends DeleteCardStates {}

class DeleteCardSuccess extends DeleteCardStates {}

class DeleteCardFailure extends DeleteCardStates {
  final String errorMessage;

  DeleteCardFailure({required this.errorMessage});
}
