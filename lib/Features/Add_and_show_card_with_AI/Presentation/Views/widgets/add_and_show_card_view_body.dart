import 'dart:developer';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/card_with_AI_entity.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/ai_card_loading.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/list_of_preview_section.dart';
import 'package:smart_cards/core/utils/helpers/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/View_model/add_and_show_card_cubit/add_and_show_card_cubit.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/View_model/add_and_show_card_cubit/add_and_show_card_states.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/custom_text_field.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/select_the_language.dart';
import 'package:smart_cards/Features/Add_normal_card/Presentation/Views/widgets/custom_selection.dart';
import 'package:smart_cards/core/utils/widgets/app_button.dart';
import 'package:smart_cards/core/utils/widgets/app_show_dialog.dart';
import 'package:smart_cards/core/utils/widgets/app_header.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/get_collections_cubit/get_collections_cubit.dart';
import 'package:smart_cards/core/views/collection_view.dart';
import 'package:smart_cards/generated/l10n.dart';

class AddAndShowCardViewBody extends StatefulWidget {
  const AddAndShowCardViewBody({super.key});

  @override
  State<AddAndShowCardViewBody> createState() => _AddAndShowCardViewBodyState();
}

class _AddAndShowCardViewBodyState extends State<AddAndShowCardViewBody>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> fadeAnimation;
  final TextEditingController textController = TextEditingController();
  String? selectedCollectionName;
  String? selectedCollectionId;
  String? word;
  String selectedLanguage = "English";

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    fadeAnimation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<AddAndShowCardCubit, AddAndShowCardStates>(
        listener: (context, state) {
          if (state is ShowCardFailure) {
            Navigator.pop(context); // Dismiss loading dialog
            AppShowDialog.buildShowSnackBar(context, state.errorMessage);
            log(state.errorMessage);
          }
          if (state is ShowCardSuccess) {
            Navigator.pop(context); // Dismiss loading dialog
            controller.forward(from: 0);
          }

          if (state is ShowCardLoading) {
            if (!context.mounted) return;
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => Center(child: AICardLoadingIndicator()),
            );
          }

        
        },
        builder: (context, state) {
          return SingleChildScrollView(
            
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //***************************************************** */
                //   Header
                AppHeader(
                  icon: Icons.auto_awesome,
                  title: S.of(context).GenerateSmartFlashcards,
                  subTitle: S.of(context).EnterAnyWordsOrSentences,
                ),
                SizedBox(height: 20.h),
                //***************************************************** */
                //   Selection section
                buildSelectionRow(),
                SizedBox(height: 18.h),
                //***************************************************** */
                //   Text field
                CustomTextField(
                  controller: textController,
                  onSubmitted: aiCardGeneration,
                  icon: Icons.search_rounded,
                  hint: S.of(context).enterWordToGenerate,
                ),
                SizedBox(height: 16.h),
                //***************************************************** */
                //  put comma between every word or sentence
                Row(
                  children: [
                    Icon(Icons.info),
                    SizedBox(width: 4.w),
                    Text(
                      S.of(context).putCommaBetweenEveryWordOrSentence,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                //***************************************************** */
                //   Preview section
                if (state is ShowCardSuccess)
                  ListOfPreviewSection(
                    fadeAnimation: fadeAnimation,
                    textController: textController,
                    selectedCollectionId: selectedCollectionId,
                    card: state.card,
                  ),
                //***************************************************** */
                //   Add card button
                if (state is ShowCardSuccess)
                  AppButton(
                    text: S.of(context).addCard,
                    onPressed: () => addAICards(state.card),
                    icon: Icons.add,
                  ),
                if (state is AddCardLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildSelectionRow() {
    return Row(
      children: [
        //   Collection selection
        Expanded(
          child: CustomSelection(
            label: selectedCollectionName ?? S.of(context).selectCollection,

            icon: Icons.collections_bookmark_rounded,
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: context.read<GetCollectionsCubit>(),
                    child: CollectionView(),
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
          ),
        ),
        SizedBox(width: 12.w),
        //   Language selection
        Expanded(
          child: CustomSelection(
            label: selectedLanguage,
            icon: Icons.language,
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SelectTheLanguage()),
              );

              if (result != null) {
                setState(() {
                  selectedLanguage = result['name'];
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Future<void> aiCardGeneration(String value) async {
    if (value.trim().isEmpty) {
      AppShowDialog.buildShowSnackBar(context, S.of(context).pleaseEnterAWord);
      return;
    }

    if (!await NetworkUtils.isOnline()) {
      AppShowDialog.buildShowSnackBar(
        context,
        S.of(context).NoInternetConnection,
      );
      return;
    }
    if (!mounted) return;
    setState(() => word = value.trim());
    context.read<AddAndShowCardCubit>().showCard(
      word: value.trim(),
      language: selectedLanguage,
    );
  }

  void addAICards(List<CardWithAIEntity> card) {
    final theWord = textController.text.trim();

    if (theWord.isEmpty || selectedCollectionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).PleaseFillAllFieldsAndSelectACollection),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    bool hasValidCards = false;
    for (var item in card) {
      if (item.is_valid == true) {
        hasValidCards = true;
        break;
      }
    }

    if (!hasValidCards) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).noValidCardsToAdd),
          backgroundColor: Colors.orange,
        ),
      );
      context.read<AddAndShowCardCubit>().reset();
      textController.clear();
      return;
    }

    int addedCount = 0;
    for (var item in card) {
      if (item.is_valid != true) {
        continue;
      }
      context.read<AddAndShowCardCubit>().addCard(
        word: item.word,
        definition: item.definition,
        example: item.example,
        type: item.type,
        image_url: item.image_url,
        collectionId: selectedCollectionId!,
      );
      addedCount++;
    }



    if (addedCount > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).CardSavedSuccessfully),
          backgroundColor: Colors.blueAccent,
          duration: Duration(milliseconds: 1500),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    textController.clear();
  }

  @override
  void dispose() {
    controller.dispose();
    textController.dispose();
    super.dispose();
  }
}
