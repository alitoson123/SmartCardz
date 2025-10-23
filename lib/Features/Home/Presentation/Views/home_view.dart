import 'package:flutter/material.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/home_view_body.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/add_options.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 2,
        centerTitle: true,
        title: const Text(
          'Smart Cardz',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: HomeViewBody(),
      floatingActionButton: AddOptions(),
    );
  }
}
