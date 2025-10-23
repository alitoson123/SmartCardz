import 'package:flutter/material.dart';

class SocialMedialLogo extends StatelessWidget {
  const SocialMedialLogo(
      {super.key,
      required this.image,
      required this.myWidth,
      required this.myheight,
      required this.onTap});
  final String image;
  final double myWidth;
  final double myheight;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: Color(0xffFFFFFF),
        radius: 20,
        child: Image.asset(
          image,
          width: myWidth,
          height: myheight,
        ),
      ),
    );
  }
}
