import 'package:dartz/dartz.dart';
import 'package:smart_cards/core/errors/failure.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_stats_entity.dart';
import 'package:smart_cards/Features/Home/Domain/Repos/collection_stats_repo/collection_stats_repo.dart';
import 'package:smart_cards/Features/Home/Data/collection_stats_local_data_source/collection_stats_local_data_source.dart';
import 'package:smart_cards/Features/Home/Data/collection_stats_remote_data_source/collection_stats_remote_data_source.dart';

class CollectionStatsRepoImpl implements CollectionStatsRepo {
  final CollectionStatsRemoteDataSource remoteDataSource;
  final CollectionStatsLocalDataSource localDataSource;

  const CollectionStatsRepoImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  // get collection stats whether from remote or local (online or offline)
  @override
  Future<Either<Failure, CollectionStatsEntity>> getCollectionStats({
    required String collectionId,
  }) async {
    try {
      // 1. Try to fetch from the remote server first to get the freshest data.
      final remoteStats = await remoteDataSource.fetchCollectionStats(
        collectionId: collectionId,
      );

      // 2. If successful, cache the new stats so we have them next time we're offline.
      await localDataSource.cacheStats(
        collectionId: collectionId,
        stats: remoteStats,
      );

      // Return the fresh data.
      return Right(remoteStats);
    } catch (e) {
      // 3. If the remote fetch fails (e.g., no internet connection), try to load from local cache.
      try {
        final localStats = await localDataSource.getCachedStats(
          collectionId: collectionId,
        );

        if (localStats != null) {
          // We found locally cached stats! Return them.
          return Right(localStats);
        } else {
          // No internet AND no cached stats. We must fail here.
          return Left(
            ServerFailure(
              errorMessage: 'No internet and no cached data available.',
            ),
          );
        }
      } catch (cacheError) {
        // Something went wrong reading from the cache.
        return Left(ServerFailure(errorMessage: cacheError.toString()));
      }
    }
  }

  // refresh all collections stats
  @override
  Future<Either<Failure, Map<String, CollectionStatsEntity>>>
  refreshAllCollectionsStats({required List<String> collectionIds}) async {
    try {
      final Map<String, CollectionStatsEntity> freshStats = {};

      //  Future.wait to execute all remote fetches in parallel.
      await Future.wait(
        collectionIds.map((id) async {
          final remoteStats = await remoteDataSource.fetchCollectionStats(
            collectionId: id,
          );
          await localDataSource.cacheStats(
            collectionId: id,
            stats: remoteStats,
          );
          freshStats[id] = remoteStats;
        }),
      );

      return Right(freshStats);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
