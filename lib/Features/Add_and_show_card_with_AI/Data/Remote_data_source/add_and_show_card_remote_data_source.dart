import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/card_with_AI_entity.dart';

abstract class AddAndShowCardRemoteDataSource {
  Future<CardWithAIEntity> showCard({required String word});
  Future<void> addCard({
    required String word,
    required String definition,
    required List<dynamic> example,
    required List<dynamic> type,
    String? image_url,
    required String collectionId,
  });
}
