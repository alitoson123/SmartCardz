import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/card_with_AI_entity.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/back_side.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/custom_card.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/front_side.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';
import 'package:smart_cards/Features/Revision/Presentation/View_model/fetch_and_rating_cubit/fetch_and_rating_cubit.dart';
import 'package:smart_cards/Features/Revision/Presentation/View_model/fetch_and_rating_cubit/fetch_and_rating_states.dart';
import 'package:smart_cards/Features/Revision/Presentation/Views/widgets/row_of_difficulty_button.dart';
import 'package:smart_cards/core/Functions/section_title.dart';
import 'package:smart_cards/core/utils/app_button.dart';

class RevisionViewBody extends StatefulWidget {
  const RevisionViewBody({super.key, required this.collection});
  final CollectionEntity collection;

  @override
  State<RevisionViewBody> createState() => _RevisionViewBodyState();
}

class _RevisionViewBodyState extends State<RevisionViewBody> {
  bool showAnswer = false;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<FetchAndRatingCubit>().fetchDueCards(
      collectionId: widget.collection.collection_id,
    );
  }

  void _resetIndex() {
    setState(() {
      currentIndex = 0;
      showAnswer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchAndRatingCubit, FetchAndRatingStates>(
      builder: (context, state) {
        if (state is FetchAndRatingLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FetchDueCardsSuccess) {
          final cards = state.cards;
          log('✅ Cards Loaded: ${cards.length}');
                    log('✅ Cards Loaded: ${cards.toString()}');


          if (cards.isEmpty) {
            return const Center(
              child: Text(
                'No cards due for review 🎉',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            );
          }

          // Ensure currentIndex is within bounds - use WidgetsBinding to avoid setState during build
          if (currentIndex >= cards.length) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _resetIndex();
            });
            return const Center(child: CircularProgressIndicator());
          }

          final card = cards[currentIndex];
          final isAICard = card.isAICard;
          log('Card front side: ${card.frontSide}');
          log('Card back side: ${card.backSide}');
          log('Card type: ${card.cardType}');
          log('Is AI Card: $isAICard');
          log('Current index: $currentIndex, Total cards: ${cards.length}');
          return Padding(
            padding: EdgeInsets.all(16.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20.h),
                  buildSectionTitle(context, 'Front Side'),
                  SizedBox(height: 10.h),

                  // 👇 لو الكارت AI نعرض الـ FrontSide widget، لو Normal نعرض Text
                  isAICard
                      ? FrontSide(card: card as CardWithAIEntity)
                      : CustomCard(
                          child: Text(
                            card.frontSide.isEmpty
                                ? 'No front side data'
                                : card.frontSide,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.green,
                            ),
                          ),
                        ),

                  if (showAnswer) ...[
                    SizedBox(height: 30.h),
                    buildSectionTitle(context, 'Back Side'),
                    SizedBox(height: 10.h),

                    // 👇 نفس الفكرة للظهر
                    isAICard
                        ? BackSide(card: card as CardWithAIEntity)
                        : CustomCard(
                            child: Text(
                              card.backSide.isEmpty
                                  ? 'No back side data'
                                  : card.backSide,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),
                  ],

                  SizedBox(height: 40.h),

                  !showAnswer
                      ? AppButton(
                          text: 'Show Answer',
                          icon: Icons.visibility,
                          onPressed: () => setState(() => showAnswer = true),
                        )
                      : RowOfDifficultyButton(
                          card: card,
                          showAnswer: showAnswer,
                          currentIndex: currentIndex,
                          collectionId: widget.collection.collection_id,
                          onNextCard: () {
                            setState(() {
                              showAnswer = false;
                              if (currentIndex < cards.length - 1) {
                                currentIndex++;
                              } else {
                                // Reset to start from beginning
                                currentIndex = 0;
                              }
                            });
                          }, 
                        ),
                ],
              ),
            ),
          );
        } else if (state is FetchAndRatingFailure) {
          log(state.errorMessage);

          return Center(child: Text('Error: ${state.errorMessage}'));
        } else if (state is SubmitRatingSuccess) {
          // Reset index when new cards are fetched - use WidgetsBinding to avoid setState during build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _resetIndex();
          });
          context.read<FetchAndRatingCubit>().fetchDueCards(
            collectionId: widget.collection.collection_id,
          );
          return const Center(
            child: Text(
              'Rating saved ✅\nLoading next card...',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          );
        } else {
          return const Center(child: Text('Unexpected state (no handler)'));
        }
      },
    );
  }
}
