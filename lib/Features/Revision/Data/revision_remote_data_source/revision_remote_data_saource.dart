import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';

abstract class RevisionRemoteDataSaource {
  Future<List<BaseCardEntity>> fetchDueCards({
    required int limit,
    required String collectionId,
  });
  Future<void> submitRating(BaseCardEntity card, int quality);
}
