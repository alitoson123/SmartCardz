import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_cards/Features/Revision/Data/Data_source/revision_remote_data_source.dart';
import 'package:smart_cards/Features/Revision/Domain/Repos/revision_repo.dart';
import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';
import 'package:smart_cards/core/errors/failure.dart';

class RevisionRepoImpl implements RevisionRepo {
  final RevisionRemoteDataSource revisionRemoteDataSource;
  RevisionRepoImpl({required this.revisionRemoteDataSource});

  @override
  Future<Either<Failure, List<BaseCardEntity>>> getDueCards({
    required String collectionId,
  }) async {
    try {
      var result = await revisionRemoteDataSource.getDueCards(
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

  @override
  Future<Either<Failure, void>> updateCard({required BaseCardEntity card}) async {
    try {
      await revisionRemoteDataSource.updateCard(card: card);

      return right(null);
    } catch (e) {
      if (e is FirebaseException) {
        return left(ServerFailure.fromFirebaseError(e));
      } else {
        return left(ServerFailure(errorMessage: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, void>> updateMultipleCards({
    required List<BaseCardEntity> cards,
  }) async {
    try {
      await revisionRemoteDataSource.updateMultipleCards(cards: cards);

      return right(null);
    } catch (e) {
      if (e is FirebaseException) {
        return left(ServerFailure.fromFirebaseError(e));
      } else {
        return left(ServerFailure(errorMessage: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, void>> deleteCard({
    required String cardId,
    required String collectionId,
  }) async {
    try {
      await revisionRemoteDataSource.deleteCard(
        cardId: cardId,
        collectionId: collectionId,
      );

      return right(null);
    } catch (e) {
      if (e is FirebaseException) {
        return left(ServerFailure.fromFirebaseError(e));
      } else {
        return left(ServerFailure(errorMessage: e.toString()));
      }
    }
  }
}
