import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:smart_cards/Features/Revision/Data/revision_remote_data_source/revision_remote_data_saource.dart';
import 'package:smart_cards/Features/Revision/Domain/Repos/revision_repo.dart';
import 'package:smart_cards/core/Entities/base_card_entity.dart';
import 'package:smart_cards/core/errors/failure.dart';

class RevisionRepoImpl extends RevisionRepo {
  final RevisionRemoteDataSaource revisionRemoteDataSaource;

  RevisionRepoImpl({required this.revisionRemoteDataSaource});
  @override
  Future<Either<Failure, List<BaseCardEntity>>> fetchDueCards({
    int limit = 50,
    required String collectionId,
  }) async {
    try {
      var result = await revisionRemoteDataSaource.fetchDueCards(
        limit: limit,
        collectionId: collectionId,
      );
      return right(result);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(errorMessage: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, void>> submitRating(
    BaseCardEntity card,
    int quality,

  ) async {
    try {
      await revisionRemoteDataSaource.submitRating(
        card,
        quality,

      );
      return right(null);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(errorMessage: e.toString()));
      }
    }
  }
}
