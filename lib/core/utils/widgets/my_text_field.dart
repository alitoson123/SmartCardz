import 'package:flutter/material.dart';
import 'package:smart_cards/Features/Auth/Sign_up/Data/Models/sign_up_model.dart';
import 'package:smart_cards/constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        floatingLabelStyle: TextStyle(color: K_PRIMARY_COLOR),
        contentPadding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 14.r),
        suffixIcon: SignUpModelObject.myIcon,
        hintText: SignUpModelObject.myHintText,
        focusedBorder: focusOutLineInputBorder(),
        border: borderOutLineInputBorder(),
      ),
    );
  }

  OutlineInputBorder borderOutLineInputBorder() {
    return OutlineInputBorder(borderRadius: BorderRadius.circular(20.r));
  }

  OutlineInputBorder focusOutLineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.r),
      borderSide: BorderSide(color: Colors.black),
    );
  }
}
