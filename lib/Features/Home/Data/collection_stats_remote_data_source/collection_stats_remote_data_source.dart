import 'package:smart_cards/Features/Home/Data/Models/collection_stats_model.dart';
import 'package:smart_cards/core/services/app_services/collection_service.dart';

abstract class CollectionStatsRemoteDataSource {
  Future<CollectionStatsModel> fetchCollectionStats({
    required String collectionId,
  });
}

class CollectionStatsRemoteDataSourceImpl
    implements CollectionStatsRemoteDataSource {
  const CollectionStatsRemoteDataSourceImpl();

  @override
  Future<CollectionStatsModel> fetchCollectionStats({
    required String collectionId,
  }) async {
    final Map<String, int> counts = await CollectionService.getCardStateCounts(
      collectionId: collectionId,
    );

    return CollectionStatsModel(
      totalCards: counts['total'] ?? 0,
      dueCards: counts['due'] ?? 0,
    );
  }
}
