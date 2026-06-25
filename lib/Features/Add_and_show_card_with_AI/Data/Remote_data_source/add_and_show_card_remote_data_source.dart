import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/card_with_AI_entity.dart';

abstract class AddAndShowCardRemoteDataSource {
  Future<List<AICardEntity>> showCard({
    required String word,
    required String inputLanguage,
    required String outputLanguage,
    required String userId,
    required String cardId,
    required bool withImage,
  });

  Future<void> addCard({
    required String word,
    required String definition,
    required List<String> example,
    required String type,
    String? image_url,
    String? aiImagePath,
    required String collectionId,
    required String cardId,
  });
}
