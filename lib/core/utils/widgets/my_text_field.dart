import 'package:flutter/material.dart';
import 'package:smart_cards/Features/Auth/Sign_up/Data/Models/sign_up_model.dart';
import 'package:smart_cards/constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/generated/l10n.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.SignUpModelObject,
    this.initialValue,
    this.visPassword = false,
  });
  final SignUpModel SignUpModelObject;
  final String? initialValue;
  final bool visPassword;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: SignUpModelObject.keyboardType,
      obscureText: visPassword,
      initialValue: initialValue,
      onChanged: SignUpModelObject.onChanged,
      validator: (value) {
        if (value!.isEmpty) {
          return '${S.of(context).pleaseEnterYour}${SignUpModelObject.myTextLabel}';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: SignUpModelObject.myTextLabel,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelStyle: TextStyle(color: AppConstants.K_PRIMARY_COLOR),
        contentPadding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 14.r),
        hintText: SignUpModelObject.myHintText,
        suffixIcon: SignUpModelObject.myIcon,
        focusedBorder: focusOutLineInputBorder(),
        border: borderOutLineInputBorder(),
      ),
    );
  }

  OutlineInputBorder borderOutLineInputBorder() {
    return OutlineInputBorder(borderRadius: BorderRadius.circular(20.r));
  }

  OutlineInputBorder focusOutLineInputBorder() {
    return OutlineInputBorder(borderRadius: BorderRadius.circular(20.r));
  }
}
