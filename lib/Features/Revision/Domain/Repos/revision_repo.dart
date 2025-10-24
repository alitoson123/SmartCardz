import 'package:dartz/dartz.dart';
import 'package:smart_cards/core/Entities/base_card_entity.dart';
import 'package:smart_cards/core/errors/failure.dart';

abstract class RevisionRepo {
  Future<Either<Failure, List<BaseCardEntity>>> fetchDueCards({int limit = 50,required String collectionName});

  Future<Either<Failure, void>> submitRating(BaseCardEntity card, int quality, String collectionName);
}
