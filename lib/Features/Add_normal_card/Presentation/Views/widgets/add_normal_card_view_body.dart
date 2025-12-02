import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/custom_text_field.dart';
import 'package:smart_cards/Features/Add_normal_card/Presentation/View_model/normal_card_cubit/normal_card_cubit.dart';
import 'package:smart_cards/core/utils/widgets/app_button.dart';
import 'package:smart_cards/core/utils/widgets/app_header.dart';
import 'package:smart_cards/core/view_model/get_collections_cubit/get_collections_cubit.dart';
import 'package:smart_cards/core/views/collection_view.dart';
import 'package:smart_cards/generated/l10n.dart';


class AddNormalCardViewBody extends StatefulWidget {
  const AddNormalCardViewBody({super.key});

  @override
  State<AddNormalCardViewBody> createState() => _AddNormalCardViewBodyState();
}

class _AddNormalCardViewBodyState extends State<AddNormalCardViewBody> {
  final TextEditingController frontSideController = TextEditingController();
  final TextEditingController backSideController = TextEditingController();
  String? selectedCollectionName;
  String? selectedCollectionId;

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
            title: S.of(context).createYourFlashcard,
                  subTitle: S.of(context).createFlashcardSubtitle,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: context.read<GetCollectionsCubit>(),
                            child:  CollectionView(),
                          ),
                        ),
                      );

                      if (result != null && result is Map<String, dynamic>) {
                        setState(() {
                          selectedCollectionName = result['name'];
                          selectedCollectionId = result['id'];
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        selectedCollectionName ?? S.of(context).selectCollection,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 18),
              ],
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: frontSideController,
              hint: S.of(context).enterFrontSide,
              icon: Icons.edit_note_rounded,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: backSideController,
              hint: S.of(context).enterBackSide,
              icon: Icons.edit_note_rounded,
              
            ),
            const SizedBox(height: 35),
            AppButton(
              text: S.of(context).addCard,
              onPressed: () {
                final frontSide = frontSideController.text.trim();
                final backSide = backSideController.text.trim();

                if (frontSide.isEmpty || backSide.isEmpty || selectedCollectionId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                      content: Text(S.of(context).PleaseFillAllFieldsAndSelectACollection),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                context.read<NormalCardCubit>().addNormalCard(
                      frontSide: frontSide,
                      backSide: backSide,
                      collectionId: selectedCollectionId!,
                    );

                frontSideController.clear();
                backSideController.clear();
              },
              icon: Icons.add,
            ),
          ],
        ),
      ),
    );
  }
}
