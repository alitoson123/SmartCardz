import 'package:dartz/dartz.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/card_with_AI_entity.dart';
import 'package:smart_cards/core/errors/failure.dart';

abstract class AddAndShowCardRepo {
  Future<Either<Failure, CardWithAIEntity>> showCard({required String word});
  Future<Either<Failure, void>> addCard({
    required String word,
    required String definition,
    required List<dynamic> example,
    required List<dynamic> type,
    String? image_url,
    required String collectionId,
  });
}
