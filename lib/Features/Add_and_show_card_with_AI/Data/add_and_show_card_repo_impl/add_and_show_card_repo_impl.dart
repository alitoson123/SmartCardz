import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Data/Remote_data_source/add_and_show_card_remote_data_source.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/card_with_AI_entity.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Repos/add_and_show_card_repo.dart';
import 'package:smart_cards/core/errors/failure.dart';

class AddAndShowCardRepoImpl extends AddAndShowCardRepo {
  final AddAndShowCardRemoteDataSource addAndShowCardRemoteDataSource;

  AddAndShowCardRepoImpl({required this.addAndShowCardRemoteDataSource});

  // show card
  @override
  Future<Either<Failure, List<AICardEntity>>> showCard({
    required String word,
    required String inputLanguage,
    required String outputLanguage,
    required String userId,
    required String cardId,
  }) async {
    try {
      var result = await addAndShowCardRemoteDataSource.showCard(
        word: word,
        inputLanguage: inputLanguage,
        outputLanguage: outputLanguage,
        userId: userId,
        cardId: cardId,
      );

      return right(result);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(errorMessage: e.toString()));
      }
    }
  }

  // add ai card
  @override
  Future<Either<Failure, void>> addCard({
    required String word,
    required String definition,
    required List<String> example,
    required String type,
    String? image_url,
    String? aiImagePath,
    required String collectionId,
  }) async {
    try {
      await addAndShowCardRemoteDataSource.addCard(
        collectionId: collectionId,
        word: word,
        definition: definition,
        example: example,
        type: type,
        image_url: image_url,
        aiImagePath: aiImagePath,
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
