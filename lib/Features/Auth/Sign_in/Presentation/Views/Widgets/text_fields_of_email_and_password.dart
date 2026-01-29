import 'package:flutter/material.dart';
import 'package:smart_cards/generated/l10n.dart';
import 'package:smart_cards/Features/Auth/Sign_up/Data/Models/sign_up_model.dart';
import 'package:smart_cards/core/utils/widgets/my_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFieldsOfEmailAndPassword extends StatefulWidget {
  const TextFieldsOfEmailAndPassword({
    super.key,
    required this.onChangedForEmail,
    required this.onChangedForPassword,
  });
  final void Function(String) onChangedForEmail;
  final void Function(String) onChangedForPassword;

  @override
  State<TextFieldsOfEmailAndPassword> createState() =>
      _TextFieldsOfEmailAndPasswordState();
}

class _TextFieldsOfEmailAndPasswordState
    extends State<TextFieldsOfEmailAndPassword> {
  bool myVisPassword = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyTextField(
          SignUpModelObject: SignUpModel(
            myTextLabel: S.of(context).Email,
            myHintText: S.of(context).Email,
            myIcon: Icon(Icons.mail),
            onChanged: widget.onChangedForEmail,
          ),
        ),
        SizedBox(height: 25.h),
        MyTextField(
          visPassword: myVisPassword,
          SignUpModelObject: SignUpModel(
            myTextLabel: S.of(context).Password,
            myHintText: S.of(context).Password,
            myIcon: GestureDetector(
              onTap: () {
                setState(() {
                  myVisPassword = !myVisPassword;
                });
              },
              child: Icon(
                myVisPassword ? Icons.visibility : Icons.visibility_off,
              ),
            ),
            onChanged: widget.onChangedForPassword,
          ),
        ),
      ],
    );
  }
}
