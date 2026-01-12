import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Data/Remote_data_source/add_and_show_card_remote_data_source.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/card_with_AI_entity.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Repos/add_and_show_card_repo.dart';
import 'package:smart_cards/core/errors/failure.dart';

class AddAndShowCardRepoImpl extends AddAndShowCardRepo {
  final AddAndShowCardRemoteDataSource addAndShowCardRemoteDataSource;

  AddAndShowCardRepoImpl({required this.addAndShowCardRemoteDataSource});


    
  @override
  Future<Either<Failure, void>> requestAI({required String word}) async {
    try {
      await addAndShowCardRemoteDataSource.requestAI(word: word);
      return right(null);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(errorMessage: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<CardWithAIEntity>>> showCard({
    required String word,
  }) async {
    try {
      var result = await addAndShowCardRemoteDataSource.showCard(word: word);
      log('The word is ${result[0].word}');
      log('The type is ${result[0].type}');
      log('The definition is ${result[0].definition}');
      log('The example is ${result[0].image_url}');

      return right(result);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(errorMessage: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, void>> addCard({
    required String word,
    required String definition,
    required List<String> example,
    required String type,
    String? image_url,
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
      );
      return right(null);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(errorMessage: e.toString()));
      }
    }
  }

}
