class NormalCardStates {}

class AddNormalCardInitial extends NormalCardStates {}

class AddNormalCardLoading extends NormalCardStates {}

class AddNormalCardSuccess extends NormalCardStates {}

class AddNormalCardFailure extends NormalCardStates {
  final String errorMessage;
  AddNormalCardFailure({required this.errorMessage});
}
