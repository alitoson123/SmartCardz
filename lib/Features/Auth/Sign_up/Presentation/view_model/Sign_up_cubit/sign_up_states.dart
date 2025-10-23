import 'package:smart_cards/Features/Auth/Domain/Entities/user_entity.dart';

class SignUpStates {}

class SignUpInitialState extends SignUpStates {}

class SignUpLoadingState extends SignUpStates {}

class SignUpSuccessState extends SignUpStates {
  final UserEntity userEntity;
  SignUpSuccessState({required this.userEntity});
}

class SignUpFailureState extends SignUpStates {
  final String errMessage;
  SignUpFailureState({required this.errMessage});
}
