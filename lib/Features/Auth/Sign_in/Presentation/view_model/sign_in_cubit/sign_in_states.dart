import 'package:smart_cards/Features/Auth/Domain/Entities/user_entity.dart';

class SignInStates {}

class SignInInitialState extends SignInStates {}

class SignInLoadingState extends SignInStates {}

class SignInSuccessState extends SignInStates {
  final UserEntity userEntity;
  SignInSuccessState({required this.userEntity});
}

class SignInErrorState extends SignInStates {
  final String errMessage;
  SignInErrorState({required this.errMessage});
}
