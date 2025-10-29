import 'package:dartz/dartz.dart';
import 'package:smart_cards/Features/Home/Data/Models/collection_model.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';
import 'package:smart_cards/core/errors/failure.dart';

abstract class AddCollectionRepo {
  Future<Either<Failure, CollectionEntity>> addCollection({
    required String collectionName,
  });

}
