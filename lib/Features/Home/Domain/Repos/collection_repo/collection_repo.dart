import 'package:dartz/dartz.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';
import 'package:smart_cards/core/errors/failure.dart';

abstract class CollectionRepo {
  Future<Either<Failure, CollectionEntity>> addCollection({
    required String collectionName,
  });
  Future<Either<Failure, List<CollectionEntity>>> getCollections();
  Future<Either<Failure, String>> deleteCollection({
    required String collectionId,
  });
  Future<Either<Failure, Map<String, String>>> renameCollection({
    required String collectionId,
    required String newName,
  });
  Future<Either<Failure, void>> moveCollection({
    required String collectionId,
    String? folderId,
  });
}
