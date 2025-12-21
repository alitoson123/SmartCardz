import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Revision/Data/Repos_impl/revision_repo_impl.dart';
import 'package:smart_cards/Features/Revision/Presentation/View_model/fetch_and_rating_cubit/fetch_and_rating_states.dart';
import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';

class FetchAndRatingCubit extends Cubit<FetchAndRatingStates> {
  FetchAndRatingCubit({required this.revisionRepoImpl})
    : super(FetchAndRatingInitial());
  final RevisionRepoImpl revisionRepoImpl;

  Future<void> fetchDueCards({required String collectionId}) async {
    emit(FetchAndRatingLoading());

    final result = await revisionRepoImpl.fetchDueCards(
      limit: 50,
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
    // 🚀 Optimistic UI: Remove the card from the local list immediately
    List<BaseCardEntity> previousCards = [];
    if (state is FetchDueCardsSuccess) {
      previousCards = (state as FetchDueCardsSuccess).cards;
      final updatedCards = List<BaseCardEntity>.from(previousCards)
        ..removeWhere((c) => c.id == card.id);
      emit(FetchDueCardsSuccess(cards: updatedCards));
    }

    final result = await revisionRepoImpl.submitRating(card, quality);

    result.fold(
      (failure) {
        // If it fails, show error.
        // Note: In a production app, we might want to rollback the list here.
        emit(FetchAndRatingFailure(errorMessage: failure.errorMessage));
      },
      (success) {
        // We stay in FetchDueCardsSuccess (the optimistic state)
      },
    );
  }
}
