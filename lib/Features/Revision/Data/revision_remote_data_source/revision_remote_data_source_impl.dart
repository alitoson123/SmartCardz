import 'package:smart_cards/Features/Revision/Data/revision_remote_data_source/revision_remote_data_saource.dart';
import 'package:smart_cards/core/Entities/base_card_entity.dart';
import 'package:smart_cards/core/services/app_services/app_services.dart';

class RevisionRemoteDataSourceImpl extends RevisionRemoteDataSaource {
  final AppServices appServices;
  @override
  RevisionRemoteDataSourceImpl({required this.appServices});
  @override
  Future<List<BaseCardEntity>> fetchDueCards({
    int limit = 50,
    required String collectionName,
  }) async {
    var result = await appServices.fetchDueCards(
      limit: limit,
      collectionName: collectionName,
    );

    return result;
  }

  @override
  Future<void> submitRating(
    BaseCardEntity card,
    int quality,
    String collectionName,
  ) async {
    await appServices.submitRating(card, quality, collectionName);
  }
}
