import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Revision/Presentation/View_model/delete_card_cubit/delete_card_states.dart';
import 'package:smart_cards/core/services/app_services/app_services.dart';

class DeleteCardCubit extends Cubit<DeleteCardStates> {
  DeleteCardCubit() : super(DeleteCardInitial());

  void deleteCard({required String cardId, required String collectionId}) {
    emit(DeleteCardLoading());
    try {
      AppServices.deleteCard(cardId: cardId, collectionId: collectionId);

      emit(DeleteCardSuccess());
    } catch (e) {
      emit(DeleteCardFailure(errorMessage: e.toString()));
    }
  }
}
