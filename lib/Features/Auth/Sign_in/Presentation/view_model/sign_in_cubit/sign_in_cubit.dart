import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Auth/Domain/Repos/auth_repo.dart';
import 'package:smart_cards/Features/Auth/Sign_in/Presentation/view_model/sign_in_cubit/sign_in_states.dart';

class SignInCubit extends Cubit<SignInStates> {
  SignInCubit(this.authRepoObject) : super(SignInInitialState());

  final AuthRepo authRepoObject;
  Future<void> signInWithEmailAndPasswordMethod({
    required String email,
    required String password,
  }) async {
    emit(SignInInitialState());
    emit(SignInLoadingState());

    final user = await authRepoObject.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    user.fold(
      (failure) => emit(SignInErrorState(errMessage: failure.errorMessage)),
      (success) => emit(SignInSuccessState(userEntity: success)),
    );
  }

  Future<void> SignInWithGoogleMethod() async {
    emit(SignInInitialState());
    emit(SignInLoadingState());
    var user = await authRepoObject.signInWithGoogle();
    user.fold(
      (Failure) => emit(SignInErrorState(errMessage: Failure.errorMessage)),
      (Sucess) => emit(SignInSuccessState(userEntity: Sucess)),
    );
  }
}
