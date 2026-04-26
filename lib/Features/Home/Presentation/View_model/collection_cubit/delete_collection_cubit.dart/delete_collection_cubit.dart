import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Home/Domain/Repos/collection_repo/collection_repo.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/delete_collection_cubit.dart/delete_collection_states.dart';

class DeleteCollectionCubit extends Cubit<DeleteCollectionStates> {
  DeleteCollectionCubit({required this.collectionRepo})
    : super(DeleteCollectionInitial());

  final CollectionRepo collectionRepo;

  Future<void> deleteCollection({required String collectionId}) async {
    emit(DeleteCollectionLoading());
    final result = await collectionRepo.deleteCollection(
      collectionId: collectionId,
    );
    result.fold(
      (failure) =>
          emit(DeleteCollectionFailure(errorMessage: failure.errorMessage)),
      (success) => emit(DeleteCollectionSuccess(collectionId: success)),
    );
  }
}
