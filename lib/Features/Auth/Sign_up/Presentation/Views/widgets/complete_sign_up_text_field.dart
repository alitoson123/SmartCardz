/*import 'package:flutter/material.dart';
import 'package:smart_cards/Features/Auth/Data/models/user_model.dart';
import 'package:smart_cards/Features/Auth/Sign_up/Data/Models/sign_up_model.dart';
import 'package:smart_cards/core/utils/my_text_field.dart';

class CompleteSignUpTextField extends StatefulWidget {
  const CompleteSignUpTextField({super.key, required this.userModelObject});
  final UserModel userModelObject;

  @override
  State<CompleteSignUpTextField> createState() =>
      _CompleteSignUpTextFieldState();
}

class _CompleteSignUpTextFieldState extends State<CompleteSignUpTextField> {
  late List<SignUpModel> SignUpModelList;

  @override
  void initState() {
    super.initState();

    SignUpModelList = [
      SignUpModel(
        keyboardType: TextInputType.name,
        myTextLabel: 'First Name',
        myHintText: 'Enter your first name',
        myIcon: Icon(Icons.person),
        onChanged: (value) {
          widget.userModelObject.Fname = value;
        },
      ),
      SignUpModel(
        keyboardType: TextInputType.name,
        myTextLabel: 'Last Name',
        myHintText: 'Enter your last name',
        myIcon: Icon(Icons.person),
        onChanged: (value) {
          widget.userModelObject.Lname = value;
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: SignUpModelList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: MyTextField(SignUpModelObject: SignUpModelList[index]),
        );
      },
    );
  }
}
*/
