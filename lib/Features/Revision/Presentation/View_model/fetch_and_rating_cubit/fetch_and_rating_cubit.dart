import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Revision/Data/Repos_impl/revision_repo_impl.dart';
import 'package:smart_cards/Features/Revision/Presentation/View_model/fetch_and_rating_cubit/fetch_and_rating_states.dart';
import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';

const List<int> againOffsets = [5, 8, 12];
const int maxAgainCount = 3;

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

  Future<void> submitRating(BaseCardEntity card, int quality) async {
    List<BaseCardEntity> previousCards = [];

    if (state is FetchDueCardsSuccess) {
      previousCards = (state as FetchDueCardsSuccess).cards;
      final updatedCards = List<BaseCardEntity>.from(previousCards);

      // شيل الكارت الحالي
      updatedCards.removeWhere((c) => c.id == card.id);

      if (quality == 0) {
        // Again
        card.againCount = (card.againCount ?? 0) + 1;

        if (card.againCount! <= maxAgainCount) {
          final offset =
              againOffsets[(card.againCount! - 1).clamp(
                0,
                againOffsets.length - 1,
              )];

          final currentIndex = previousCards.indexWhere((c) => c.id == card.id);

          final safeIndex = currentIndex == -1 ? 0 : currentIndex;

          final insertIndex = (safeIndex + offset < updatedCards.length)
              ? safeIndex + offset
              : updatedCards.length;

          updatedCards.insert(insertIndex, card);
        }
      }

      emit(FetchDueCardsSuccess(cards: updatedCards));
    }

    // SM-2 شغال زي ما هو
    await revisionRepoImpl.submitRating(card, quality);
  }
}
