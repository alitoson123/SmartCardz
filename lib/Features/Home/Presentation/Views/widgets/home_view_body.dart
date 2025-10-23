import 'package:flutter/material.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/item_of_collections.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 2,
      itemBuilder: (context, index) {
        return ItemOfCollections();
      },
    );
  }
}
