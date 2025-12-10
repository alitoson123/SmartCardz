import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Add_normal_card/Data/Repos_impl/normal_card_repo_impl.dart';
import 'package:smart_cards/Features/Add_normal_card/Presentation/View_model/normal_card_cubit/normal_card_states.dart';

class NormalCardCubit extends Cubit<NormalCardStates> {
  NormalCardCubit({required this.normalCardRepoImpl}) : super(AddNormalCardInitial());

  final NormalCardRepoImpl normalCardRepoImpl;

  Future<void> addNormalCard({
    required String frontSide,
    required String backSide,
    required String frontImageUrl,
    required String backImageUrl,
    required String collectionId,
  }) async {
    emit(AddNormalCardLoading());
    final result = await normalCardRepoImpl.addNormalCard(
      frontSide: frontSide,
      backSide: backSide,
      frontImageUrl: frontImageUrl,
      backImageUrl: backImageUrl,
      collectionId: collectionId,
    );
    result.fold(
      (failure) =>
          emit(AddNormalCardFailure(errorMessage: failure.errorMessage)),
      (success) => emit(AddNormalCardSuccess()),
    );
  }
}
