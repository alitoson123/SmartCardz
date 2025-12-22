import 'package:flutter/material.dart';
import 'package:smart_cards/core/services/notifications_service/push_notification_service.dart';
import 'package:smart_cards/generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:smart_cards/Features/Auth/Sign_in/Presentation/Views/Widgets/sign_in_view_body.dart';
import 'package:smart_cards/Features/Auth/Sign_in/Presentation/view_model/sign_in_cubit/sign_in_cubit.dart';
import 'package:smart_cards/Features/Auth/Sign_in/Presentation/view_model/sign_in_cubit/sign_in_states.dart';
import 'package:smart_cards/constant.dart';
import 'package:smart_cards/core/messages/message.dart';
import 'package:smart_cards/core/services/Shared_preferences_service/shared_preferences.dart';
import 'package:smart_cards/core/navigator/routes.dart';
import 'package:smart_cards/core/services/notifications_service/back_ground_service.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Opacity(opacity: .5, child: Text(S.of(context).signInTitle)),
      ),
      body: BloconsumerOfSignInBody(),
    );
  }
}

class BloconsumerOfSignInBody extends StatelessWidget {
  const BloconsumerOfSignInBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInCubit, SignInStates>(
      listener: (context, state) async {
        if (state is SignInErrorState) {
          Message().MessageErrorMethod(context, message: state.errMessage);
        }
        if (state is SignInSuccessState) {
          Message().MessageSuccessMethod(
            context,
            message: 'Sign in successfully',
          );
          await SharedPreferencesService.instance.setBool(K_IS_LOGIN, true);

          PushNotificationService.saveToken();

          //  BackGroundService().subscribeToTopics();

          context.go(AppRoutes.homeScreen);
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is SignInLoadingState ? true : false,
          child: SignInViewBody(),
        );
      },
    );
  }
}
