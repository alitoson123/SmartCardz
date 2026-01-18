import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Revision/Data/Repos_impl/revision_repo_impl.dart';
import 'package:smart_cards/Features/Revision/Presentation/View_model/fetch_and_rating_cubit/fetch_and_rating_states.dart';
import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';

class FetchAndRatingCubit extends Cubit<FetchAndRatingStates> {
  FetchAndRatingCubit({required this.revisionRepoImpl})
    : super(FetchAndRatingInitial());
  final RevisionRepoImpl revisionRepoImpl;

  Future<void> fetchDueCards({
    required int limit,
    required String collectionId,
  }) async {
    emit(FetchAndRatingLoading());

    final result = await revisionRepoImpl.fetchDueCards(
      limit: limit,
      collectionId: collectionId,
    );
    result.fold(
      (failure) =>
          emit(FetchAndRatingFailure(errorMessage: failure.errorMessage)),
      (success) {
        emit(FetchDueCardsSuccess(cards: success));
      },
    );
  }

Future<void> submitRating(
  BaseCardEntity card,
  int quality,
  String collectionId,
) async {
  // 🚀 Optimistic UI
  List<BaseCardEntity> previousCards = [];

  if (state is FetchDueCardsSuccess) {
    previousCards = (state as FetchDueCardsSuccess).cards;
    final updatedCards = List<BaseCardEntity>.from(previousCards);

    // شيل الكارت الحالي
    updatedCards.removeWhere((c) => c.id == card.id);

    if (quality == 0) {
      // Again → يرجع بعد عدد كروت
      const int againOffset = 7;

      final currentIndex =
          previousCards.indexWhere((c) => c.id == card.id);

      final insertIndex =
          (currentIndex + againOffset < updatedCards.length)
              ? currentIndex + againOffset
              : updatedCards.length;

      updatedCards.insert(insertIndex, card);
    }

    // Easy / Medium / Hard
    // الكارت اتشال وخلاص

    emit(FetchDueCardsSuccess(cards: updatedCards));
  }

  final result = await revisionRepoImpl.submitRating(card, quality);

  result.fold(
    (failure) {
      emit(
        FetchAndRatingFailure(
          errorMessage: failure.errorMessage,
        ),
      );
    },
    (success) {
      // optimistic state is already applied
    },
  );
}
}
