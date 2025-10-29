import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';
import 'package:smart_cards/core/Data/collection_remote_data_source/collection_remote_data_source.dart';
import 'package:smart_cards/core/Domain/Repos/collection_repo/collection_repo.dart';
import 'package:smart_cards/core/errors/failure.dart';

class CollectionRepoImpl extends CollectionRepo {
  final CollectionRemoteDataSource collectionRemoteDataSource;
  CollectionRepoImpl({required this.collectionRemoteDataSource});
  @override
  Future<Either<Failure, List<CollectionEntity>>> getCollection() async {
    try {
      var result = await collectionRemoteDataSource.getCollections();

      return right(result);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(errorMessage: e.toString()));
      }
    }
  }
}
