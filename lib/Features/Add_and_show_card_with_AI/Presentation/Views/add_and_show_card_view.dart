import 'package:flutter/material.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/add_and_show_card_view_body.dart';

class AddAndShowCardView extends StatelessWidget {
  const AddAndShowCardView({super.key, required this.collectionId});
  final String collectionId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f5f9),
      appBar:  AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 2,
        centerTitle: true,
        title: const Text(
          'Add New Card with AI',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: AddAndShowCardViewBody(),
    );
  }
}
