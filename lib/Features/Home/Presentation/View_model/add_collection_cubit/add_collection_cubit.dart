import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Home/Domain/Repos/add_collection_repo/add_collection_repo.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/add_collection_cubit/add_collection_states.dart';

class AddCollectionCubit extends Cubit<AddCollectionStates> {
  AddCollectionCubit({required this.addCollectionRepo})
    : super(AddCollectionInitial());

  final AddCollectionRepo addCollectionRepo;

  Future<void> addCollectionMethod({required String collectionName}) async {
    emit(AddCollectionLoading());

    final result = await addCollectionRepo.addCollection(
      collectionName: collectionName,
    );

    result.fold(
      (failure) => emit(AddCollectionFailure(errMessage: failure.errorMessage)),
      (success) => emit(AddCollectionSuccess(collectionEntity: success)),
    );
  }
}
