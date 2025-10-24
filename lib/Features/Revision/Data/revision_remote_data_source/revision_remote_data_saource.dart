import 'package:smart_cards/core/Entities/base_card_entity.dart';

abstract class RevisionRemoteDataSaource {
  Future<List<BaseCardEntity>> fetchDueCards({
    int limit = 50,
    required String collectionName,
  });
  Future<void> submitRating(
    BaseCardEntity card,
    int quality,
    String collectionName,
  );
}
