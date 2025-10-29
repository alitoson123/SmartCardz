import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/custom_text_field.dart';
import 'package:smart_cards/Features/Add_normal_card/Presentation/View_model/normal_card_cubit/normal_card_cubit.dart';
import 'package:smart_cards/core/utils/app_button.dart';
import 'package:smart_cards/core/utils/app_header.dart';

class AddNormalCardViewBody extends StatefulWidget {
  const AddNormalCardViewBody({super.key, required this.collectionId});
  final String collectionId;

  @override
  State<AddNormalCardViewBody> createState() => _AddNormalCardViewBodyState();
}

class _AddNormalCardViewBodyState extends State<AddNormalCardViewBody> {
  final TextEditingController frontSideController = TextEditingController();
  final TextEditingController backSideController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppHeader(
              icon: Icons.library_add,
              title: 'Create Your Flashcard',
              subTitle: 'Add a new word and its definition to your deck',
            ),
            const SizedBox(height: 30),
            CustomTextField(
              controller: frontSideController,
              hint: 'Enter the front side',
              icon: Icons.edit_note_rounded,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: backSideController,
              hint: 'Enter the back side',
              icon: Icons.edit_note_rounded,
              maxLines: 3,
            ),
            const SizedBox(height: 35),
            AppButton(
              text: 'Add Card',
              onPressed: () {
                final frontSide = frontSideController.text.trim();
                final backSide = backSideController.text.trim();
                if (frontSide.isEmpty || backSide.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill all fields'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                context.read<NormalCardCubit>().addNormalCard(
                  frontSide: frontSide,
                  backSide: backSide, collectionId: widget.collectionId ,
                );
                frontSideController.clear();
                backSideController.clear();
              }, icon: Icons.add,
            ),
          ],
        ),
      ),
    );
  }
}
