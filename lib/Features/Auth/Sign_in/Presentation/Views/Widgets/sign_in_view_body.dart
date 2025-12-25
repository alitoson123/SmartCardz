import 'package:flutter/material.dart';
import 'package:smart_cards/generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Auth/Domain/Entities/user_entity.dart';
import 'package:smart_cards/Features/Auth/Sign_in/Presentation/Views/Widgets/row_of_dont_have_an_account_and_sign_up.dart';
import 'package:smart_cards/Features/Auth/Sign_in/Presentation/Views/Widgets/test_logo.dart';
import 'package:smart_cards/Features/Auth/Sign_in/Presentation/Views/Widgets/text_button_of_forget_password.dart';
import 'package:smart_cards/Features/Auth/Sign_in/Presentation/Views/Widgets/text_fields_of_email_and_password.dart';
import 'package:smart_cards/Features/Auth/Sign_in/Presentation/Views/Widgets/text_of_title_and_subtitle.dart';
import 'package:smart_cards/Features/Auth/Sign_in/Presentation/view_model/sign_in_cubit/sign_in_cubit.dart';
import 'package:smart_cards/core/utils/widgets/app_button.dart';

class SignInViewBody extends StatefulWidget {
  const SignInViewBody({super.key});

  @override
  State<SignInViewBody> createState() => _SignInViewBodyState();
}

class _SignInViewBodyState extends State<SignInViewBody> {
  UserEntity? userEntityObject;
  String? email;
  String? Password;
  GlobalKey<FormState> myKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: SingleChildScrollView(
        child: Form(
          key: myKey,
          autovalidateMode: autovalidateMode,
          child: Column(
            children: [
              SizedBox(height: 25.h),
              TextOfTitleAndSubtitle(
                title: S.of(context).welcome,
                subtitle: S.of(context).signInSubtitle,
              ),
              SizedBox(height: 30.h),
              TextFieldsOfEmailAndPassword(
                onChangedForEmail: (value) {
                  email = value;
                },
                onChangedForPassword: (value) {
                  Password = value;
                },
              ),

              SizedBox(height: 15.h),
              TextButtonOfForgetPassword(),
              SizedBox(height: 15.h),
              AppButton(
                onPressed: () async {
                  if (myKey.currentState!.validate()) {
                    myKey.currentState!.save();

                    BlocProvider.of<SignInCubit>(
                      context,
                    ).signInWithEmailAndPasswordMethod(
                      email: email!,
                      password: Password!,
                    );
                  } else {
                    setState(() {
                      autovalidateMode = AutovalidateMode.always;
                    });
                  }
                },
                text: S.of(context).signInTitle,
                icon: Icons.login,
              ),

              SizedBox(height: 35.h),

              GoogleSignInButton(
                onPressed: () async {
                  BlocProvider.of<SignInCubit>(
                    context,
                  ).SignInWithGoogleMethod();
                },
              ),

              //  RowOfSocialMediaLogos(),
              SizedBox(height: 20.h),
              RowOfDontHaveAnAccountAndSignUp(),
            ],
          ),
        ),
      ),
    );
  }
}
