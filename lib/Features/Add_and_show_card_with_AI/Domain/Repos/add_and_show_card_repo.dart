import 'package:dartz/dartz.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/card_with_AI_entity.dart';
import 'package:smart_cards/core/errors/failure.dart';

abstract class AddAndShowCardRepo {

  Future<Either<Failure, List<AICardEntity>>> showCard({
    required String word,
    required String inputLanguage,
    required String outputLanguage,
    required String userId,
    required String cardId,
  });

  Future<Either<Failure, void>> addCard({
    required String word,
    required String definition,
    required List<String> example,
    required String type,
    String? image_url,
    String? aiImagePath,
    required String collectionId,
  });
  
}
