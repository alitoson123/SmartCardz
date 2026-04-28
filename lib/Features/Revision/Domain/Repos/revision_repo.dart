import 'package:dartz/dartz.dart';
import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';
import 'package:smart_cards/core/errors/failure.dart';

abstract class RevisionRepo {
  Future<Either<Failure, List<BaseCardEntity>>> getDueCards({
    required String collectionId,
  });

  Future<Either<Failure, void>> updateCard({required BaseCardEntity card});

  Future<Either<Failure, void>> updateMultipleCards({
    required List<BaseCardEntity> cards,
  });

  Future<Either<Failure, void>> deleteCard({
    required String cardId,
    required String collectionId,
  });
}
