import 'package:flutter/material.dart';

class Mylistgenerate extends StatelessWidget {
  const Mylistgenerate({super.key, required this.currentIndex});
  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.all(2),
            child: Container(
              width: index == currentIndex ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
