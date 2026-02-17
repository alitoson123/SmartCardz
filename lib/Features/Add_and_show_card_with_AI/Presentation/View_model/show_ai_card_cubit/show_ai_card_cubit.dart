import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Data/add_and_show_card_repo_impl/add_and_show_card_repo_impl.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/View_model/show_ai_card_cubit/show_ai_card_states.dart';

class ShowAICardCubit extends Cubit<ShowAICardStates> {
  final AddAndShowCardRepoImpl addAndShowCardRepoImpl;

  ShowAICardCubit({required this.addAndShowCardRepoImpl})
    : super(ShowAICardInitial());

  Future<void> showAICard({
    required String word,
    required String language,
  }) async {
    emit(ShowAICardLoading());

    final result = await addAndShowCardRepoImpl.showCard(
      word: word,
      language: language,
    );

    result.fold(
      (failure) => emit(ShowAICardFailure(errorMessage: failure.errorMessage)),
      (card) => emit(ShowAICardSuccess(card: card)),
    );
  }

  void reset() => emit(ShowAICardInitial());
}
