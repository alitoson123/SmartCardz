import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Home/Data/Repo_impl/collection_repo_impl.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/get_collections_cubit/get_collections_states.dart';

class GetCollectionsCubit extends Cubit<GetCollectionsStates> {
  GetCollectionsCubit({required this.collectionRepoImpl})
    : super(GetCollectionsLoading());

  final CollectionRepoImpl collectionRepoImpl;

  Future<void> getCollections() async {
    final result = await collectionRepoImpl.getCollections();
    result.fold(
      (failure) =>
          emit(GetCollectionsFailure(errMessage: failure.errorMessage)),
      (success) => emit(GetCollectionsSuccess(collections: success)),
    );
  }
}
