/*import 'package:flutter/material.dart';
import 'package:smart_cards/Features/Auth/Data/Repos/auth_repo_impl.dart';
import 'package:smart_cards/Features/Auth/Data/models/user_model.dart';
import 'package:smart_cards/Features/Auth/Sign_in/Presentation/Views/Widgets/text_of_title_and_subtitle.dart';
import 'package:smart_cards/Features/Auth/Sign_up/Presentation/Views/widgets/complete_sign_up_text_field.dart';
import 'package:smart_cards/constant.dart';
import 'package:smart_cards/core/messages/message.dart';
import 'package:smart_cards/core/services/ARUD_user/ARUD_user.dart';
import 'package:smart_cards/core/services/firebase_auth_service/firebase_auth_service.dart';
import 'package:smart_cards/core/utils/app_button.dart';

class CompleteSignUpView extends StatefulWidget {
  const CompleteSignUpView({super.key});

  @override
  State<CompleteSignUpView> createState() => _CompleteSignUpViewState();
}

class _CompleteSignUpViewState extends State<CompleteSignUpView> {
  final GlobalKey<FormState> myKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final UserModel userModelObject = UserModel(
    email: '',
    useruid: '',
    Fname: '',
    Lname: '',
  );
  @override
  Widget build(BuildContext context) {
    return Form(
      key: myKey,
      autovalidateMode: autovalidateMode,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Opacity(opacity: .5, child: Text('Sign Up')),
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                TextOfTitleAndSubtitle(
                  title: 'Complete Profile',
                  subtitle:
                      'Complete your details or continue \n with social media',
                ), // shift alt a
                SizedBox(height: 30),
                CompleteSignUpTextField(userModelObject: userModelObject),
                AppButton(
                  onPressed: () async {
                    if (myKey.currentState!.validate()) {
                      myKey.currentState!.save();
                      Message().MessageSuccessMethod(
                        context,
                        message: 'Sign up successfully.',
                      );

                      await AuthRepoImpl(
                        arudUserObject: ArudUser(),
                        authObject: Auth(),
                      ).addUser(
                        data: userModelObject,
                        MapOfData: userModelObject.toMapOfSignUp(),
                      );

                      //   GoRouter.of(context).push(Navigate.KHomePage);
                    } else {
                      setState(() {
                        autovalidateMode = AutovalidateMode.always;
                      });
                    }
                  },
                  text: 'Continue',
                  icon: Icons.arrow_forward,
                ),
                SizedBox(height: 20),

                Opacity(
                  opacity: .6,
                  child: Text(
                    'By continuing your confirm that you agree \n with our term and condition',
                    textAlign: TextAlign.center,
                    style: Style().textStyle16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/