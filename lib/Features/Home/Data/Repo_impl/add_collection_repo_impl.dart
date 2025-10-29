import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smart_cards/Features/Home/Data/Models/collection_model.dart';
import 'package:smart_cards/Features/Home/Data/add_collection_local_data_source/add_collection_local_data_source.dart';
import 'package:smart_cards/Features/Home/Data/add_collection_remote_data_source/add_collection_remote_data_source.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';
import 'package:smart_cards/Features/Home/Domain/Repos/add_collection_repo/collection_repo.dart';
import 'package:smart_cards/core/errors/failure.dart';

class AddCollectionRepoImpl extends CollectionRepo {
  final AddCollectionRemoteDataSource addCollectionRemoteDataSource;
  //final AddCollectionLocalDataSource addCollectionLocalDataSource;
  AddCollectionRepoImpl({
    //required this.addCollectionLocalDataSource,
    required this.addCollectionRemoteDataSource,
  });
  @override
  Future<Either<Failure, CollectionModel>> addCollection({
    required String collectionName,
  }) async {
    try {
    var result =  await addCollectionRemoteDataSource.addCollection(
        collectionName: collectionName,
      );
    //  addCollectionLocalDataSource.addCollection(
     //   collectionName: collectionName,
     // );
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
  Future<Either<Failure, CollectionEntity>> getCollection({
    required String collectionName,
  }) {
    // TODO: implement getCollection
    throw UnimplementedError();
  }
}
