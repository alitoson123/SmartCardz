class ForgetPasswordStates {}

class ForgetPasswordInitialState extends ForgetPasswordStates {}

class ForgetPasswordLoadingState extends ForgetPasswordStates {}

class ForgetPasswordSuccessState extends ForgetPasswordStates {}

class ForgetPasswordFailureState extends ForgetPasswordStates {
  final String errMessage;

  ForgetPasswordFailureState({required this.errMessage});
}
