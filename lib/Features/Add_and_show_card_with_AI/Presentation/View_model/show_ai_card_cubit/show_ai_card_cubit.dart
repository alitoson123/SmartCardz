import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Repos/add_and_show_card_repo.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Repos/quota_repo.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/View_model/show_ai_card_cubit/show_ai_card_states.dart';

class ShowAICardCubit extends Cubit<ShowAICardStates> {
  final AddAndShowCardRepo addAndShowCardRepo;
  final QuotaRepo quotaRepo;

  ShowAICardCubit({required this.addAndShowCardRepo, required this.quotaRepo})
    : super(ShowAICardInitial());

  Future<void> showAICard({
    required String word,
    required String inputLanguage,
    required String outputLanguage,
    required String userId,
    required String cardId,
    required bool withImage,
  }) async {
    emit(ShowAICardLoading());

    // 1. Calculate requested count
    final List<String> wordsList = word
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    final int requestedCount = wordsList.isEmpty ? 1 : wordsList.length;

    // 2. Check quota
    final quotaCheck = await quotaRepo.canGenerateCards(
      userId: userId,
      requestedCount: requestedCount,
      withImage: withImage,
    );

    int allowedCount = 0;
    bool quotaError = false;

    quotaCheck.fold(
      (failure) {
        emit(ShowAICardFailure(errorMessage: failure.errorMessage));
        quotaError = true;
      },
      (count) {
        allowedCount = count;
      },
    );

    if (quotaError) return;

    if (allowedCount == 0) {
      emit(ShowAICardQuotaExceeded(withImage: withImage));
      return;
    }

    //  if the user is not pro and the requested count is greater than the allowed count
    //  then we will generate the cards with the allowed count and show a warning message
    String adjustedWord = word;
    bool isPartial = allowedCount < requestedCount;
    if (isPartial) {
      adjustedWord = wordsList.take(allowedCount).join(', ');
    }

    // 3. Generate cards
    final result = await addAndShowCardRepo.showCard(
      word: adjustedWord,
      inputLanguage: inputLanguage,
      outputLanguage: outputLanguage,
      userId: userId,
      cardId: cardId,
      withImage: withImage,
    );

    result.fold(
      (failure) => emit(ShowAICardFailure(errorMessage: failure.errorMessage)),
      (cards) async {
        // 4. Deduct quota
        final deductionResult = await quotaRepo.deductQuota(
          userId: userId,
          generatedCount: cards.length,
          withImage: withImage,
        );
        deductionResult.fold(
          (failure) =>
              emit(ShowAICardFailure(errorMessage: "Failed to deduct quota.")),
          (success) {
            if (isPartial) {
              emit(
                ShowAICardSuccessWithWarning(
                  card: cards,
                  requestedCount: requestedCount,
                  allowedCount: allowedCount,
                ),
              );
            } else {
              emit(ShowAICardSuccess(card: cards));
            }
          },
        );
      },
    );
  }

  void reset() => emit(ShowAICardInitial());
}
