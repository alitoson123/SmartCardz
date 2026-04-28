import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/card_with_AI_entity.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/View_model/add_ai_card_cubit/add_ai_card_cubit.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/View_model/add_ai_card_cubit/add_ai_states.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/ai_card_loading.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/list_of_preview_section.dart';
import 'package:smart_cards/core/messages/message.dart';
import 'package:smart_cards/core/utils/helpers/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/View_model/show_ai_card_cubit/show_ai_card_cubit.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/View_model/show_ai_card_cubit/show_ai_card_states.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/custom_text_field.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/select_language_pair.dart';
import 'package:smart_cards/Features/Add_normal_card/Presentation/Views/widgets/custom_selection.dart';
import 'package:smart_cards/core/utils/widgets/app_button.dart';
import 'package:smart_cards/core/utils/widgets/app_header.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/get_collections_cubit/get_collections_cubit.dart';
import 'package:smart_cards/core/views/collection_view.dart';
import 'package:smart_cards/core/views/widgets/app_dialog.dart';
import 'package:smart_cards/core/views/widgets/banner_ad_widget.dart';
import 'package:smart_cards/core/views/widgets/interstitial_add_widget.dart';
import 'package:smart_cards/generated/l10n.dart';

class AddAndShowCardViewBody extends StatefulWidget {
  const AddAndShowCardViewBody({super.key});

  @override
  State<AddAndShowCardViewBody> createState() => _AddAndShowCardViewBodyState();
}

class _AddAndShowCardViewBodyState extends State<AddAndShowCardViewBody>
    with SingleTickerProviderStateMixin {
  // ✅ Add these two lines with your existing fields
  final InterstitialAdManager interstitialAdManager = InterstitialAdManager();
  int cardSaveCount = 0;
  late AnimationController controller;
  late Animation<double> fadeAnimation;
  final TextEditingController textController = TextEditingController();
  String? selectedCollectionName;
  String? selectedCollectionId;
  String? word;
  String selectedInputLanguage = "English";
  late String selectedOutputLanguage = selectedInputLanguage;
  final String cardId = FirebaseFirestore.instance.collection('cards').doc().id;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    fadeAnimation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    interstitialAdManager.loadAd();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: BlocConsumer<ShowAICardCubit, ShowAICardStates>(
        listener: (context, state) {
          if (state is ShowAICardFailure) {
            setState(() => isLoading = false);
            Message().showAppDialog(
              context: context,
              type: DialogType.error,
              message: state.errorMessage,
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
            child: Column(
              children: [
                Expanded(
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
                          suffixIcon: IconButton(
                            icon: CircleAvatar(
                              backgroundColor: theme.primaryColor,
                              radius: 16.r,
                              child: Icon(
                                Icons.arrow_upward,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                            ),
                            onPressed: () =>
                                aiCardGeneration(textController.text),
                          ),
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
                              Expanded(
                                child: Text(
                                  S
                                      .of(context)
                                      .putCommaBetweenEveryWordOrSentence,
                                  textAlign: TextAlign.left,
                                ),
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

                                cardSaveCount++;
                                //   if (cardSaveCount % 2 == 0) {
                                interstitialAdManager.showAd();
                                //    }

                                Message().MessageSuccessMethod(
                                  context,
                                  message: S.of(context).CardSavedSuccessfully,
                                );
                              }
                              if (addState is AddAICardFailure) {
                                setState(() => isLoading = false);
                                Message().showAppDialog(
                                  context: context,
                                  type: DialogType.error,
                                  message: addState.errorMessage,
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
                ),

                const BannerAdWidget(),
              ],
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
            label: "$selectedInputLanguage to $selectedOutputLanguage",
            icon: Icons.language,
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SelectLanguagePair(),
                ),
              );

              if (result != null) {
                setState(() {
                  selectedInputLanguage = result['input_name'];
                  selectedOutputLanguage = result['output_name'];
                });
              }
            },
          ),
        ),
      ],
    );
  }

  // helper function to format any user input into a comma-separated string
  String _formatInputToSpecialFormat(String rawInput) {
    if (rawInput.isEmpty) return '';
    // 1. Replace newlines, tabs, semicolons, and Arabic commas with standard commas
    String formatted = rawInput.replaceAll(RegExp(r'[\n\r\t;،|]'), ',');
    // 2. Split by comma
    List<String> parts = formatted.split(',');
    // 3. Clean spaces and remove empty items
    List<String> cleanedParts = parts
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    // 4. Join with a comma and space
    return cleanedParts.join(', ');
  }

  // ai card generation
  Future<void> aiCardGeneration(String value) async {
    // dismiss the keyboard
    FocusScope.of(context).unfocus();

    // format the input to comma-separated
    String formattedValue = _formatInputToSpecialFormat(value);

    // check if the text field is empty
    if (formattedValue.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).pleaseEnterAWord),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // check internet connection
    if (!await NetworkUtils.isOnline()) {
      Message().showAppDialog(
        context: context,
        type: DialogType.error,
        message: S.of(context).NoInternetConnection,
      );
      return;
    }

    // check if the widget is mounted
    if (!mounted) return;

    // set the word
    setState(() => word = formattedValue);


    // show ai card
    context.read<ShowAICardCubit>().showAICard(
      word: formattedValue,
      inputLanguage: selectedInputLanguage,
      outputLanguage: selectedOutputLanguage,
      userId: FirebaseAuth.instance.currentUser!.uid,
      cardId: cardId,
    );
  }

  // add ai cards
  Future<void> addAICards(List<AICardEntity> cards) async {
    if (selectedCollectionId == null) {
      Message().showAppDialog(
        context: context,
        type: DialogType.warning,
        message: S.of(context).PleaseSelectACollection,
      );
  //   context.push(AppRoutes.);

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
      Message().showAppDialog(
        context: context,
        type: DialogType.warning,
        message: S.of(context).noValidCardsToAdd,
      );
      // reset the state
      context.read<ShowAICardCubit>().reset();
      // clear the text field
      textController.clear();
      return;
    }

    // Check the network connection
    if (!await NetworkUtils.isOnline()) {
      if (!mounted) return;
      Message().showAppDialog(
        context: context,
        type: DialogType.error,
        message: S.of(context).NoInternetConnection,
      );
      return;
    }
    // add ai cards
    context.read<AddAICardCubit>().addAllAICards(
      cards: cards,
      collectionId: selectedCollectionId!,
      cardId: cardId,
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
