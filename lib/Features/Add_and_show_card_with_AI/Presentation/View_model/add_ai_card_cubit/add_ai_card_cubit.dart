import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Data/add_and_show_card_repo_impl/add_and_show_card_repo_impl.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/card_with_AI_entity.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/View_model/add_ai_card_cubit/add_ai_states.dart';

class AddAICardCubit extends Cubit<AddAICardStates> {
  AddAICardCubit({required this.addAndShowCardRepoImpl})
    : super(AddAICardInitial());

  final AddAndShowCardRepoImpl addAndShowCardRepoImpl;

  Future<void> addAllAICards({
    required List<AICardEntity> cards,
    required String collectionId,
  }) async {
    emit(AddAICardLoading());
    try {
      for (var card in cards) {
        if (card.is_valid != true) continue; // skip invalid cards

        final result = await addAndShowCardRepoImpl.addCard(
          word: card.word,
          definition: card.definition,
          example: card.example,
          type: card.type,
          image_url: card.image_url,
          aiImagePath: card.aiImagePath,
          collectionId: collectionId,
        );

        result.fold((failure) => throw failure.errorMessage, (_) {});
        // الـ throw بيكسر الـ loop ومش بيخلي الـ emit(Success) يتنفذ خالص.
        //الـ catch بيمسكه - >  emit(AddAICardFailure)
      }
      emit(AddAICardSuccess());
    } catch (e) {
      emit(AddAICardFailure(errorMessage: e.toString()));
    }
  }

  void reset() => emit(AddAICardInitial());
}
