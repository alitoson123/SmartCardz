import 'package:dartz/dartz.dart';
import 'package:smart_cards/core/errors/failure.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_stats_entity.dart';

abstract class CollectionStatsRepo {
  // get collection stats whether from remote or local (online or offline)
  Future<Either<Failure, CollectionStatsEntity>> getCollectionStats({
    required String collectionId,
  });

  // refresh all collections stats
  Future<Either<Failure, Map<String, CollectionStatsEntity>>>
  refreshAllCollectionsStats({required List<String> collectionIds});
}
