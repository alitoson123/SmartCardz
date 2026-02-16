import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Data/add_and_show_card_repo_impl/add_and_show_card_repo_impl.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/View_model/add_and_show_card_cubit/add_and_show_card_states.dart';

class AddAndShowCardCubit extends Cubit<AddAndShowCardStates> {
  final AddAndShowCardRepoImpl addAndShowCardRepoImpl;

  AddAndShowCardCubit({required this.addAndShowCardRepoImpl})
    : super(AddAndShowCardInitial());

  Future<void> showCard({
    required String word,
    required String language,
  }) async {
    emit(ShowCardLoading());

    final result = await addAndShowCardRepoImpl.showCard(
      word: word,
      language: language,
    );

    result.fold(
      (failure) => emit(
        ShowCardFailure(errorMessage: failure.errorMessage),
      ),
      (card) => emit(ShowCardSuccess(card: card)),
    );
  }

  Future<void> addCard({
    required String word,
    required String definition,
    required List<String> example,
    required String type,
    String? image_url,
    required String collectionId,
  }) async {
    emit(AddCardLoading());

    final result = await addAndShowCardRepoImpl.addCard(
      word: word,
      definition: definition,
      example: example,
      type: type,
      image_url: image_url,
      collectionId: collectionId,
    );

    result.fold((failure) {
      emit(AddCardFailure(errorMessage: failure.errorMessage));
      log(failure.errorMessage);
    }, (card) => emit(AddCardSuccess()));
  }

  // Optional reset method if you’re using the combined Add+Show screen
  void reset() => emit(AddAndShowCardInitial());
}
