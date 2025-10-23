import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:smart_cards/Features/Auth/Data/Repos/auth_repo_impl.dart';
import 'package:smart_cards/Features/Auth/Forget_Password/Presentation/Views/Widgets/forget_password_view_body.dart';
import 'package:smart_cards/Features/Auth/Forget_Password/Presentation/view_model/Forget_password_cubit/forget_password_cubit.dart';
import 'package:smart_cards/Features/Auth/Forget_Password/Presentation/view_model/Forget_password_cubit/forget_password_states.dart';
import 'package:smart_cards/core/messages/message.dart';
import 'package:smart_cards/core/services/locator_service/service_locator.dart';

class ForgetPasswordView extends StatelessWidget {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgetPasswordCubit(
        getIt<AuthRepoImpl>(),
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Opacity(opacity: .5, child: Text('Forgot Password')),
          backgroundColor: Colors.white,
        ),
        body: blocConsumerOfForgetPasswordViewBody(),
      ),
    );
  }
}

class blocConsumerOfForgetPasswordViewBody extends StatelessWidget {
  const blocConsumerOfForgetPasswordViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgetPasswordCubit, ForgetPasswordStates>(
      listener: (context, state) {
        if (state is ForgetPasswordSuccessState) {
          Message().MessageSuccessMethod(context,
              message:
                  'Password Reset Email Sent Successfully, please check your email and login with your new password.');
          GoRouter.of(context).pop();
        }
        if (state is ForgetPasswordFailureState) {
          Message().MessageErrorMethod(context, message: state.errMessage);
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
            inAsyncCall: state is ForgetPasswordLoadingState ? true : false,
            child: ForgetPasswordViewBody());
      },
    );
  }
}
