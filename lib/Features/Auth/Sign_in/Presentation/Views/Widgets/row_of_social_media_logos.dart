import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Auth/Sign_in/Presentation/Views/Widgets/social_medial_logo.dart';
import 'package:smart_cards/Features/Auth/Sign_in/Presentation/view_model/sign_in_cubit/sign_in_cubit.dart';

class RowOfSocialMediaLogos extends StatelessWidget {
  const RowOfSocialMediaLogos({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialMedialLogo(
          image: 'assets/images/garden.png',
          myWidth: 30,
          myheight: 30,
          onTap: () async {
            BlocProvider.of<SignInCubit>(context).SignInWithGoogleMethod();
          },
        ),
      ],
    );
  }
}
