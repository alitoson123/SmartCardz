import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/card_with_AI_entity.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/View_model/add_ai_card_cubit/add_ai_card_cubit.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/View_model/add_ai_card_cubit/add_ai_states.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/ai_card_loading.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/list_of_preview_section.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collections_stats_cubit/collections_stats_cubit.dart';
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
import 'package:smart_cards/generated/l10n.dart';
import 'package:smart_cards/core/views/widgets/banner_ad_widget.dart';
import 'package:smart_cards/core/views/widgets/interstitial_add_widget.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/View_model/quota_cubit/quota_cubit.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/View_model/quota_cubit/quota_states.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/quota_entity.dart';

class AddAndShowCardViewBody extends StatefulWidget {
  const AddAndShowCardViewBody({super.key});

  @override
  State<AddAndShowCardViewBody> createState() => _AddAndShowCardViewBodyState();
}

class _AddAndShowCardViewBodyState extends State<AddAndShowCardViewBody>
    with SingleTickerProviderStateMixin {
  // for google ads
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
  bool generateWithImage = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    fadeAnimation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    // for google ads
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
          if (state is ShowAICardQuotaExceeded) {
            setState(() => isLoading = false);
            _showUpgradeBottomSheet(
              context,
              title: 'Quota Exceeded',
              message: state.withImage
                  ? 'You have run out of image flashcard generation quota.'
                  : 'You have reached your daily limit for text flashcards.',
            );
          }
          if (state is ShowAICardSuccessWithWarning) {
            setState(() => isLoading = false);
            context.read<QuotaCubit>().fetchQuota(FirebaseAuth.instance.currentUser!.uid);
            _showUpgradeBottomSheet(
              context,
              title: 'Partial Generation',
              message:
                  'You requested ${state.requestedCount} flashcards, but only ${state.allowedCount} free generations remain today.\nUpgrade to Cardify Pro for unlimited AI flashcard generation.',
            );
            controller.forward(from: 0);
          }
          if (state is ShowAICardSuccess) {
            setState(() => isLoading = false);
            context.read<QuotaCubit>().fetchQuota(FirebaseAuth.instance.currentUser!.uid);
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
                        // Quota and Settings
                        _buildQuotaAndSettings(),
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
                        if (state is ShowAICardSuccess || state is ShowAICardSuccessWithWarning)
                          ListOfPreviewSection(
                            fadeAnimation: fadeAnimation,
                            textController: textController,
                            selectedCollectionId: selectedCollectionId,
                            card: state is ShowAICardSuccess 
                                ? state.card 
                                : (state as ShowAICardSuccessWithWarning).card,
                          ),
                        //***************************************************** */
                        //   Add card button
                        if (state is ShowAICardSuccess || state is ShowAICardSuccessWithWarning)
                          BlocConsumer<AddAICardCubit, AddAICardStates>(
                            listener: (context, addState) {
                              if (addState is AddAICardSuccess) {
                                setState(() => isLoading = false);

                                context.read<ShowAICardCubit>().reset();

                                // for google ads
                                cardSaveCount++;
                                if (cardSaveCount % 2 == 0) {
                                  interstitialAdManager.showAd();
                                }

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
                                onPressed: () => addAICards(state is ShowAICardSuccess 
                                    ? state.card 
                                    : (state as ShowAICardSuccessWithWarning).card),
                                icon: Icons.add,
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
                // for google ads
                const BannerAdWidget(),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showUpgradeBottomSheet(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12.h),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Maybe Later'),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                        RevenueCatUI.presentPaywallIfNeeded('cardify_pro');
                      },
                      child: const Text('Upgrade to Pro'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuotaAndSettings() {
    return Column(
      children: [
        SwitchListTile(
          title: Text(
            'Generate with Images',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: const Text('Requires premium quota or free welcome bonus'),
          value: generateWithImage,
          onChanged: (val) {
            setState(() {
              generateWithImage = val;
            });
          },
          secondary: Icon(
            generateWithImage ? Icons.image : Icons.hide_image,
            color: generateWithImage
                ? Theme.of(context).primaryColor
                : Colors.grey,
          ),
        ),
        BlocBuilder<QuotaCubit, QuotaStates>(
          builder: (context, state) {
            if (state is QuotaLoadedSuccessfully) {
              int textLimit = state.isPro 
                  ? QuotaEntity.premiumTextLimit 
                  : QuotaEntity.dailyFreeTextLimit;
              int remainingText = state.isPro
                  ? (textLimit - state.quota.premiumTextCardsUsed)
                  : state.quota.remainingFreeText;

              int imageLimit = state.isPro 
                  ? QuotaEntity.premiumImageLimit 
                  : QuotaEntity.lifetimeFreeImageLimit;
              int remainingImage = state.isPro
                  ? (imageLimit - state.quota.premiumImageCardsUsed)
                  : state.quota.remainingFreeImage;

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      generateWithImage
                          ? 'Image Quota: $remainingImage / $imageLimit'
                          : 'Text Quota: $remainingText / $textLimit',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (!state.isPro)
                      GestureDetector(
                        onTap: () =>
                            RevenueCatUI.presentPaywallIfNeeded('cardify_pro'),
                        child: Text(
                          'Upgrade',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
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
      withImage: generateWithImage,
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
    if (mounted) {
      await context.read<AddAICardCubit>().addAllAICards(
        cards: cards,
        collectionId: selectedCollectionId!,
      );
    }

    if (!mounted) return;
    context.read<CollectionsStatsCubit>().forceRefreshCollection(
      selectedCollectionId!,
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
