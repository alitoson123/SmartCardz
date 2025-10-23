import 'package:flutter/material.dart';

class SignUpModel {
  final String myTextLabel;
  final String myHintText;
  final Icon myIcon;
  void Function(String)? onChanged;
  final TextInputType? keyboardType;

  SignUpModel(
      {this.keyboardType,
      required this.myTextLabel,
      required this.myHintText,
      required this.myIcon,
      this.onChanged});
}
