import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Revision/Data/Repos_impl/revision_repo_impl.dart';
import 'package:smart_cards/Features/Revision/Presentation/View_model/fetch_and_rating_cubit/fetch_and_rating_states.dart';

class FetchAndRatingCubit extends Cubit<FetchAndRatingStates> {
  FetchAndRatingCubit({required this.revisionRepoImpl})
    : super(FetchAndRatingInitial());
  final RevisionRepoImpl revisionRepoImpl;

  Future<void> fetchDueCards() async {
    emit(FetchAndRatingLoading());

    final result = await revisionRepoImpl.fetchDueCards(
      limit: 50,
      collectionName: 'English',
    );
    result.fold(
      (failure) =>
          emit(FetchAndRatingFailure(errorMessage: failure.errorMessage)),
      (success) {
        emit(FetchDueCardsSuccess(cards: success));
      },
    );
  }

  Future<void> submitRating(Object card, int quality) async {
    final result = await revisionRepoImpl.submitRating(
      card,
      quality,
      'English',
    );
    result.fold(
      (failure) =>
          emit(FetchAndRatingFailure(errorMessage: failure.errorMessage)),
      (success) async {
        await fetchDueCards(); // بعد التحديث فعليًا
      },
    );
  }
}
