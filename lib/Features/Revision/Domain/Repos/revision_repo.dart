import 'package:dartz/dartz.dart';
import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';
import 'package:smart_cards/core/errors/failure.dart';

abstract class RevisionRepo {
  Future<Either<Failure, List<BaseCardEntity>>> fetchDueCards({
    required int limit,
    required String collectionId,
  });

  Future<Either<Failure, void>> submitRating(BaseCardEntity card, int quality);
}
