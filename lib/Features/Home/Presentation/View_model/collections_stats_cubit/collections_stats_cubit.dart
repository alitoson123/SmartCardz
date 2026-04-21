import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Home/Domain/Repos/collection_stats_repo/collection_stats_repo.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collections_stats_cubit/collections_stats_states.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_stats_entity.dart';

class CollectionsStatsCubit extends Cubit<CollectionsStatsState> {
  final CollectionStatsRepo _collectionStatsRepo;

  final Map<String, CollectionStatsEntity> _statsCache = {};

  CollectionsStatsCubit({required CollectionStatsRepo repository})
    : _collectionStatsRepo = repository,
      super(CollectionsStatsInitial());

  /// Method called by the UI to fetch stats for a SINGLE collection.
  /// It first checks if we already have it in cache to avoid unnecessary DB calls.
  Future<void> getStatsForCollection(String collectionId) async {
    // If we already loaded this, just re-emit success with existing data.
    if (_statsCache.containsKey(collectionId)) {
      emit(CollectionsStatsSuccess(statsMap: Map.of(_statsCache)));
      return;
      /*  why this check?
      
      // ListView.builder only builds the items that are visible on the screen.
        // If you scroll down, Flutter destroys item #1 to save memory.
        // If you scroll back up, Flutter re-creates item #1.
        // Every time item #1 is re-created, its initState() runs again!

        // The _statsCache in the Cubit acts as a fast "memory safe" to say:
        // "Hey, we already downloaded the stats for Collection A five seconds ago when it was first visible.
        // Don't download it again just because the user scrolled down and back up."
      */
    }

    emit(CollectionsStatsLoading());

    // Tell the repository to fetch the data.
    final result = await _collectionStatsRepo.getCollectionStats(
      collectionId: collectionId,
    );

    // Fold the Either result from dartz
    result.fold(
      (failure) {
        // Log or handle the failure gracefully. Emit an error state for the UI.
        emit(CollectionsStatsFailure(errorMessage: failure.errorMessage));
      },
      (successStatsEntity) {
        // Success! Save it to our local map, and emit the total map to the UI.
        _statsCache[collectionId] = successStatsEntity;
        emit(CollectionsStatsSuccess(statsMap: Map.of(_statsCache)));
      },
    );
  }

  // Called by the RefreshIndicator when the user pulls down to refresh the list manually.
  Future<void> refreshAll(List<String> collectionIds) async {
    emit(CollectionsStatsLoading());

    // Tell the repo to force refresh everything and overwrite its cache.
    final result = await _collectionStatsRepo.refreshAllCollectionsStats(
      collectionIds: collectionIds,
    );

    result.fold(
      (failure) {
        emit(CollectionsStatsFailure(errorMessage: failure.errorMessage));
      },
      (successStatsMap) {
        _statsCache.clear();
        _statsCache.addAll(successStatsMap);

        emit(CollectionsStatsSuccess(statsMap: Map.of(_statsCache)));
      },
    );
  }

  /// Forces a database refresh for a single collection, bypassing the memory cache.
  /// This guarantees the user sees accurate info when returning from the revision screen.
  Future<void> forceRefreshCollection(String collectionId) async {
    final result = await _collectionStatsRepo.getCollectionStats(
      collectionId: collectionId,
    );

    result.fold(
      (failure) {
        // If it fails (e.g. no internet), just stick to the old cached data
        if (_statsCache.containsKey(collectionId)) {
          emit(CollectionsStatsSuccess(statsMap: Map.of(_statsCache)));
        } else {
          emit(CollectionsStatsFailure(errorMessage: failure.errorMessage));
        }
      },
      (successStatsEntity) {
        // Overwrite old data with fresh data
        _statsCache[collectionId] = successStatsEntity;
        emit(CollectionsStatsSuccess(statsMap: Map.of(_statsCache)));
      },
    );
  }
}
