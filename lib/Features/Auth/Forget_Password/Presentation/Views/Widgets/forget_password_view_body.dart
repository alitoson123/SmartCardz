import 'package:flutter/material.dart';
import 'package:smart_cards/generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Auth/Forget_Password/Presentation/view_model/Forget_password_cubit/forget_password_cubit.dart';
import 'package:smart_cards/Features/Auth/Sign_in/Presentation/Views/Widgets/row_of_dont_have_an_account_and_sign_up.dart';
import 'package:smart_cards/Features/Auth/Sign_in/Presentation/Views/Widgets/text_of_title_and_subtitle.dart';
import 'package:smart_cards/Features/Auth/Sign_up/Data/Models/sign_up_model.dart';
import 'package:smart_cards/core/utils/widgets/app_button.dart';
import 'package:smart_cards/core/utils/widgets/my_text_field.dart';

class ForgetPasswordViewBody extends StatefulWidget {
  const ForgetPasswordViewBody({super.key});

  @override
  State<ForgetPasswordViewBody> createState() => _ForgetPasswordViewBodyState();
}

class _ForgetPasswordViewBodyState extends State<ForgetPasswordViewBody> {
  String? email;
  final GlobalKey<FormState> myKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: myKey,
      autovalidateMode: autovalidateMode,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              SizedBox(height: 20),
              TextOfTitleAndSubtitle(
                title: S.of(context).forgotPasswordTitle,
                subtitle: S.of(context).forgotPasswordSubtitle,
              ),
              SizedBox(height: 70),
              MyTextField(
                SignUpModelObject: SignUpModel(
                  myTextLabel: S.of(context).Email,
                  myHintText: S.of(context).Email,
                  myIcon: Icon(Icons.mail),
                  onChanged: (value) {
                    email = value;
                  },
                ),
              ),
              SizedBox(height: 110),
              AppButton(
                onPressed: () async {
                  if (myKey.currentState!.validate()) {
                    myKey.currentState!.save();

                    await BlocProvider.of<ForgetPasswordCubit>(
                      context,
                    ).ForgetPasswordCubitMethod(email: email!);
                  } else {
                    setState(() {
                      autovalidateMode = AutovalidateMode.always;
                    });
                  }
                },
                text: S.of(context).send,
                icon: Icons.arrow_forward_rounded,
              ),
              SizedBox(height: 70),
              RowOfDontHaveAnAccountAndSignUp(),
            ],
          ),
        ),
      ),
    );
  }
}
