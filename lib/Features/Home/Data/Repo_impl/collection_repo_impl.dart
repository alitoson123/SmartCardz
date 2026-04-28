import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_cards/Features/Home/Data/collection_remote_data_source/collection_remote_data_source.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';
import 'package:smart_cards/Features/Home/Domain/Repos/collection_repo/collection_repo.dart';
import 'package:smart_cards/core/errors/failure.dart';
import 'package:smart_cards/core/services/app_services/collection_service.dart';

class CollectionRepoImpl extends CollectionRepo {
  final CollectionRemoteDataSource collectionRemoteDataSource;
  CollectionRepoImpl({required this.collectionRemoteDataSource});

  // create new collection
  @override
  Future<Either<Failure, CollectionEntity>> addCollection({
    required String collectionName,
  }) async {
    try {
      var result = await collectionRemoteDataSource.addCollection(
        collectionName: collectionName,
      );

      return right(result);
    } catch (e) {
      if (e is FirebaseException) {
        return left(ServerFailure.fromFirebaseError(e));
      } else {
        return left(ServerFailure(errorMessage: e.toString()));
      }
    }
  }

  // get user collections
  @override
  Future<Either<Failure, List<CollectionEntity>>> getCollections() async {
    try {
      var result = await collectionRemoteDataSource.getCollections();

      return right(result);
    } catch (e) {
      if (e is FirebaseException) {
        return left(ServerFailure.fromFirebaseError(e));
      } else {
        return left(ServerFailure(errorMessage: e.toString()));
      }
    }
  }

  // delete a collection
  @override
  Future<Either<Failure, String>> deleteCollection({
    required String collectionId,
  }) async {
    try {
      var result = await CollectionService.deleteCollection(
        collectionId: collectionId,
      );

      return right(result);
    } catch (e) {
      if (e is FirebaseException) {
        return left(ServerFailure.fromFirebaseError(e));
      } else {
        return left(ServerFailure(errorMessage: e.toString()));
      }
    }
  }

  // rename a collection
  @override
  Future<Either<Failure, Map<String, String>>> renameCollection({
    required String collectionId,
    required String newName,
  }) async {
    try {
      var result = await CollectionService.renameCollection(
        collectionId: collectionId,
        newCollectionName: newName,
      );

      return right(result);
    } catch (e) {
      if (e is FirebaseException) {
        return left(ServerFailure.fromFirebaseError(e));
      } else {
        return left(ServerFailure(errorMessage: e.toString()));
      }
    }
  }
}
