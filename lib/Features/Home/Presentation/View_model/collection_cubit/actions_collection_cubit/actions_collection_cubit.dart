import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Home/Domain/Repos/collection_repo/collection_repo.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/actions_collection_cubit/actions_collection_states.dart';

class ActionsCollectionCubit extends Cubit<ActionsCollectionStates> {
  ActionsCollectionCubit({required this.collectionRepo})
    : super(ActionsCollectionInitial());

  final CollectionRepo collectionRepo;

  // add collection
  Future<void> addCollectionMethod({required String collectionName}) async {
    emit(ActionsCollectionLoading());
    final result = await collectionRepo.addCollection(
      collectionName: collectionName,
    );

    result.fold(
      (failure) =>
          emit(ActionsCollectionFailure(errMessage: failure.errorMessage)),
      (success) => emit(AddCollectionSuccess(collectionEntity: success)),
    );
  }

  // delete collection
  Future<void> deleteCollection({required String collectionId}) async {
    emit(ActionsCollectionLoading());
    final result = await collectionRepo.deleteCollection(
      collectionId: collectionId,
    );
    result.fold(
      (failure) =>
          emit(ActionsCollectionFailure(errMessage: failure.errorMessage)),
      (success) => emit(DeleteCollectionSuccess(collectionId: success)),
    );
  }

  // rename collection
  Future<void> renameCollection({
    required String collectionId,
    required String newName,
  }) async {
    emit(ActionsCollectionLoading());
    final result = await collectionRepo.renameCollection(
      collectionId: collectionId,
      newName: newName,
    );
    result.fold(
      (failure) =>
          emit(ActionsCollectionFailure(errMessage: failure.errorMessage)),
      (success) => emit(
        RenameCollectionSuccess(
          collectionName: success['collection_name']!,
          collectionId: success['collection_id']!,
        ),
      ),
    );
  }

  // move collection
  Future<void> moveCollection({
    required String collectionId,
    String? folderId,
  }) async {
    emit(ActionsCollectionLoading());
    final result = await collectionRepo.moveCollection(
      collectionId: collectionId,
      folderId: folderId,
    );
    result.fold(
      (failure) =>
          emit(ActionsCollectionFailure(errMessage: failure.errorMessage)),
      (success) => emit(
        MoveCollectionSuccess(
          collectionId: collectionId,
          folderId: folderId,
        ),
      ),
    );
  }
}
