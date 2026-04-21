import 'package:dartz/dartz.dart';
import 'package:smart_cards/Features/Add_normal_card/Data/normal_card_remote_data_source/normal_card_remote_data_source_impl.dart';
import 'package:smart_cards/Features/Add_normal_card/Domain/Repos/normal_card_repo.dart';
import 'package:smart_cards/core/errors/failure.dart';
import 'package:firebase_core/firebase_core.dart';

class NormalCardRepoImpl extends NormalCardRepo {
  final NormalCardRemoteDataSourceImpl normalCardRemoteDataSourceImpl;

  NormalCardRepoImpl({required this.normalCardRemoteDataSourceImpl});

  // add normal card
  @override
  Future<Either<Failure, void>> addNormalCard({
    required String frontSide,
    required String backSide,
    required String frontImageUrl,
    required String backImageUrl,
    required String frontImagePath,
    required String backImagePath,
    required String collectionId,
    String? cardId,
  }) async {
    try {
      await normalCardRemoteDataSourceImpl.addNormalCard(
        frontSide: frontSide,
        backSide: backSide,
        frontImageUrl: frontImageUrl,
        backImageUrl: backImageUrl,
        frontImagePath: frontImagePath,
        backImagePath: backImagePath,
        collectionId: collectionId,
        cardId: cardId,
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
