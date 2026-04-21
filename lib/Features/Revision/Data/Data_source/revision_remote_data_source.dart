import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';
import 'package:smart_cards/core/services/app_services/card_service.dart';

class RevisionRemoteDataSource {
  final CardService cardService;
  const RevisionRemoteDataSource({required this.cardService});

  // get due cards
  Future<List<BaseCardEntity>> getDueCards({
    required String collectionId,
  }) async {
    return await cardService.getDueCards(collectionId);
  }

  // update card
  Future<void> updateCard({required BaseCardEntity card}) async {
    await cardService.updateCard(card);
  }

  // update multiple cards
  Future<void> updateMultipleCards({
    required List<BaseCardEntity> cards,
  }) async {
    await cardService.updateMultipleCards(cards);
  }

  // delete card
  Future<void> deleteCard({
    required String cardId,
    required String collectionId,
  }) async {
    await cardService.deleteCard(cardId: cardId, collectionId: collectionId);
  }
}
