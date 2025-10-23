import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Auth/Domain/Repos/auth_repo.dart';
import 'package:smart_cards/Features/Auth/Sign_up/Presentation/view_model/Sign_up_cubit/sign_up_states.dart';

class SignUpCubit extends Cubit<SignUpStates> {
  SignUpCubit(this.authRepoObject) : super(SignUpInitialState());
  final AuthRepo authRepoObject;

  Future<void> signUpMethod({
    required String email,
    required String password,
    required String Fname,
    required String Lname,
  }) async {
    emit(SignUpInitialState());
    emit(SignUpLoadingState());
    var result = await authRepoObject.signup(
      email: email,
      password: password,
      Fname: Fname,
      Lname: Lname,
    );

    result.fold(
      (failure) => emit(SignUpFailureState(errMessage: failure.errorMessage)),
      (success) => emit(SignUpSuccessState(userEntity: success)),
    );
  }
}
