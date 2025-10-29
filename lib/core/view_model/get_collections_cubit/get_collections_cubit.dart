import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/core/Data/repo_impl/collection_repo_impl/collection_repo_impl.dart';
import 'package:smart_cards/core/view_model/get_collections_cubit/get_collections_states.dart';

class GetCollectionsCubit extends Cubit<GetCollectionsStates> {
  GetCollectionsCubit({required this.collectionRepoImpl})
    : super(GetCollectionsInitial());

  final CollectionRepoImpl collectionRepoImpl;

  Future<void> getCollections() async {
    emit(GetCollectionsLoading());
    final result = await collectionRepoImpl.getCollection();
    result.fold(
      (failure) =>
          emit(GetCollectionsFailure(errMessage: failure.errorMessage)),
      (success) => emit(GetCollectionsSuccess(collections: success)),
    );
  }
}
