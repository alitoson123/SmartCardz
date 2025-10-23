
import 'package:flutter/material.dart';
import 'package:smart_cards/Features/Auth/Sign_up/Data/Models/sign_up_model.dart';
import 'package:smart_cards/constant.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.SignUpModelObject,
    this.initialValue,
  });
  final SignUpModel SignUpModelObject;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: SignUpModelObject.keyboardType,
      initialValue: initialValue,
      obscureText: SignUpModelObject.myTextLabel == 'Password' ||
              SignUpModelObject.myTextLabel == 'Confirm Password'
          ? true
          : false,
      onChanged: SignUpModelObject.onChanged,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please Enter your ${SignUpModelObject.myTextLabel}';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: SignUpModelObject.myTextLabel,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelStyle: TextStyle(color: KPrimaryColor),
        contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 18),
        suffixIcon: SignUpModelObject.myIcon,
        hintText: SignUpModelObject.myHintText,
        focusedBorder: focusOutLineInputBorder(),
        border: borderOutLineInputBorder(),
      ),
    );
  }

  OutlineInputBorder borderOutLineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
    );
  }

  OutlineInputBorder focusOutLineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: Colors.black),
    );
  }
}
