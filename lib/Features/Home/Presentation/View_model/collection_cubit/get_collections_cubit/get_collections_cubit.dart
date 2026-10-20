import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:smart_cards/Features/Home/Data/Repo_impl/collection_repo_impl.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/get_collections_cubit/get_collections_states.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';

class GetCollectionsCubit extends Cubit<GetCollectionsStates> {
  GetCollectionsCubit({required this.collectionRepoImpl})
    : super(GetCollectionsInitial());

  final CollectionRepoImpl collectionRepoImpl;

  Future<void> getCollections() async {
    emit(GetCollectionsLoading());
    final result = await collectionRepoImpl.getCollections();
    result.fold(
      (failure) =>
          emit(GetCollectionsFailure(errMessage: failure.errorMessage)),
      (success) => emit(GetCollectionsSuccess(collections: success)),
    );
  }

  void removeCollectionLocally(String collectionId) {
    if (state is GetCollectionsSuccess) {
      final currentState = state as GetCollectionsSuccess;
      final updatedList = currentState.collections
          .where((element) => element.collection_id != collectionId)
          .toList();
      emit(GetCollectionsLoading());
      emit(GetCollectionsSuccess(collections: updatedList));
    }
  }

  void addCollectionLocally(CollectionEntity collection) {
    if (state is GetCollectionsSuccess) {
      final currentState = state as GetCollectionsSuccess;
      final updatedList = List<CollectionEntity>.from(currentState.collections)
        ..add(collection); // Add to the bottom of the list
      emit(GetCollectionsLoading());
      emit(GetCollectionsSuccess(collections: updatedList));
    } else {
      getCollections(); // If not loaded yet, just fetch
    }
  }

  void renameCollectionLocally(String collectionId, String newName) {
    if (state is GetCollectionsSuccess) {
      final currentState = state as GetCollectionsSuccess;
      final updatedList = currentState.collections
          .map(
            (e) => e.collection_id == collectionId
                ? e.copyWith(collectionName: newName)
                : e,
          )
          .toList();
      emit(GetCollectionsLoading());
      emit(GetCollectionsSuccess(collections: updatedList));
    }
  }

  /// Updates the [folderId] of a collection in-memory so the home list
  /// reflects a move action immediately, without a network round-trip.
  void moveCollectionLocally(String collectionId, String? folderId) {
    if (state is GetCollectionsSuccess) {
      final currentState = state as GetCollectionsSuccess;
      final updatedList = currentState.collections
          .map(
            (e) => e.collection_id == collectionId
                ? e.copyWith(folder_id: folderId)
                : e,
          )
          .toList();
      emit(GetCollectionsLoading());
      emit(GetCollectionsSuccess(collections: updatedList));
    }
  }

  /// When a folder is deleted, all collections that belonged to it are moved
  /// back to root (folder_id = null) in-memory, without a network round-trip.
  void unassignFolderLocally(String folderId) {
    if (state is GetCollectionsSuccess) {
      final currentState = state as GetCollectionsSuccess;
      final updatedList = currentState.collections
          .map(
            (e) => e.folder_id == folderId ? e.copyWith(folder_id: null) : e,
          )
          .toList();
      emit(GetCollectionsLoading());
      emit(GetCollectionsSuccess(collections: updatedList));
    }
  }
}

