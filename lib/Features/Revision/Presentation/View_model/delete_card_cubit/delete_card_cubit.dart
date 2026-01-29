import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Revision/Presentation/View_model/delete_card_cubit/delete_card_states.dart';
import 'package:smart_cards/core/services/app_services/app_services.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

class DeleteCardCubit extends Cubit<DeleteCardStates> {
  DeleteCardCubit() : super(DeleteCardInitial());

  Future<void> deleteCard({
    required String cardId,
    required String collectionId,
  }) async {
    emit(DeleteCardLoading());

    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      emit(DeleteCardFailure(errorMessage: "No Internet Connection"));
      return;
    }

    try {
      await AppServices.deleteCard(cardId: cardId, collectionId: collectionId);

      emit(DeleteCardSuccess());
    } catch (e) {
      emit(DeleteCardFailure(errorMessage: e.toString()));
    }
  }
}
