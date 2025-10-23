import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Auth/Domain/Repos/auth_repo.dart';
import 'package:smart_cards/Features/Auth/Forget_Password/Presentation/view_model/Forget_password_cubit/forget_password_states.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordStates> {
  ForgetPasswordCubit(this.authRepoObject)
      : super(ForgetPasswordInitialState());

  final AuthRepo authRepoObject;
  Future<void> ForgetPasswordCubitMethod({required String email}) async {
    emit(ForgetPasswordInitialState());

    var result = await authRepoObject.forgetPassword(email: email);

    return result.fold(
      (failure) =>
          emit(ForgetPasswordFailureState(errMessage: failure.errorMessage)),
      (success) => emit(ForgetPasswordSuccessState()),
    );
  }
}
