import 'package:dartz/dartz.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/card_with_AI_entity.dart';
import 'package:smart_cards/core/errors/failure.dart';

abstract class AddAndShowCardRepo {
  Future<Either<Failure, void>> requestAI({required String word});
  Future<Either<Failure, List<CardWithAIEntity>>> showCard({required String word,required String language});
  Future<Either<Failure, void>> addCard({
    required String word,
    required String definition,
    required List<String> example,
    required String type,
    String? image_url,
    required String collectionId,
  });
}
