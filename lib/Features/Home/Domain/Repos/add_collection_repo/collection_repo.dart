import 'package:dartz/dartz.dart';
import 'package:smart_cards/Features/Home/Data/Models/collection_model.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';
import 'package:smart_cards/core/errors/failure.dart';

abstract class CollectionRepo {
  Future<Either<Failure, CollectionModel>> addCollection({
    required String collectionName,
  });
  Future<Either<Failure, CollectionEntity>> getCollection({
    required String collectionName,
  });
}
