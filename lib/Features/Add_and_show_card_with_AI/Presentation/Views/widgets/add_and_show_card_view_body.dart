import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/card_with_AI_entity.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/View_model/add_ai_card_cubit/add_ai_card_cubit.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/View_model/add_ai_card_cubit/add_ai_states.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/ai_card_loading.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/list_of_preview_section.dart';
import 'package:smart_cards/core/utils/helpers/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/View_model/show_ai_card_cubit/show_ai_card_cubit.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/View_model/show_ai_card_cubit/show_ai_card_states.dart';
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
  bool isLoading = false;

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
      child: BlocConsumer<ShowAICardCubit, ShowAICardStates>(
        listener: (context, state) {
          if (state is ShowAICardFailure) {
            setState(() => isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state is ShowAICardSuccess) {
            setState(() => isLoading = false);
            controller.forward(from: 0);
          }

          if (state is ShowAICardLoading) {
            setState(() => isLoading = true);
          }
        },
        builder: (context, state) {
          return ModalProgressHUD(
            // show loading indicator
            inAsyncCall: isLoading,
            progressIndicator: state is ShowAICardLoading
                ? AICardLoadingIndicator()
                : Center(child: CircularProgressIndicator()),
            child: SingleChildScrollView(
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
                  if (state is! ShowAICardLoading)
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
                  if (state is ShowAICardSuccess)
                    ListOfPreviewSection(
                      fadeAnimation: fadeAnimation,
                      textController: textController,
                      selectedCollectionId: selectedCollectionId,
                      card: state.card,
                    ),
                  //***************************************************** */
                  //   Add card button
                  if (state is ShowAICardSuccess)
                    BlocConsumer<AddAICardCubit, AddAICardStates>(
                      listener: (context, addState) {
                        if (addState is AddAICardSuccess) {
                          setState(() => isLoading = false);
                          context.read<ShowAICardCubit>().reset();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                S.of(context).CardSavedSuccessfully,
                              ),
                              backgroundColor: Colors.blueAccent,
                              duration: Duration(milliseconds: 1500),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                        if (addState is AddAICardFailure) {
                          setState(() => isLoading = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(addState.errorMessage),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                        if (addState is AddAICardLoading) {
                          setState(() => isLoading = true);
                        }
                      },
                      builder: (context, addState) {
                        return AppButton(
                          text: S.of(context).addCard,
                          onPressed: () => addAICards(state.card),
                          icon: Icons.add,
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  //  selection row
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

  // ai card generation
  Future<void> aiCardGeneration(String value) async {
    // check if the text field is empty
    if (value.trim().isEmpty) {
      AppShowDialog.buildShowSnackBar(context, S.of(context).pleaseEnterAWord);
      return;
    }

    // check internet connection
    if (!await NetworkUtils.isOnline()) {
      AppShowDialog.buildShowSnackBar(
        context,
        S.of(context).NoInternetConnection,
      );
      return;
    }

    // check if the widget is mounted
    if (!mounted) return;

    // set the word
    setState(() => word = value.trim());

    // show ai card
    context.read<ShowAICardCubit>().showAICard(
      word: value.trim(),
      language: selectedLanguage,
    );
  }

  // add ai cards
  void addAICards(List<AICardEntity> cards) {
    final theWord = textController.text.trim();

    // check if the text field is empty or the collection is not selected
    if (theWord.isEmpty || selectedCollectionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).PleaseFillAllFieldsAndSelectACollection),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // check if there are valid cards
    bool hasValidCards = false;
    for (var item in cards) {
      if (item.is_valid == true) {
        hasValidCards = true;
        break;
      }
    }
    // if there are no valid cards show a message
    if (!hasValidCards) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).noValidCardsToAdd),
          backgroundColor: Colors.orange,
        ),
      );
      // reset the state
      context.read<ShowAICardCubit>().reset();
      // clear the text field
      textController.clear();
      return;
    }
    // add ai cards
    context.read<AddAICardCubit>().addAllAICards(
      cards: cards,
      collectionId: selectedCollectionId!,
    );
    // clear the text field
    textController.clear();
  }

  @override
  void dispose() {
    controller.dispose();
    textController.dispose();
    super.dispose();
  }
}
