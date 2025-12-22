import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:smart_cards/Features/Revision/Data/revision_remote_data_source/revision_remote_data_saource.dart';
import 'package:smart_cards/constant.dart';
import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';
import 'package:smart_cards/core/services/Local_service/general_local_service.dart';
import 'package:smart_cards/core/services/app_services/app_services.dart';

class RevisionRemoteDataSourceImpl extends RevisionRemoteDataSaource {
  final AppServices appServices;
  @override
  RevisionRemoteDataSourceImpl({required this.appServices});
  @override
  Future<List<BaseCardEntity>> fetchDueCards({
    required int limit,
    required String collectionId,
  }) async {
    final connectivity = await Connectivity().checkConnectivity();

    if (connectivity != ConnectivityResult.none) {
      // Online
      var result = await appServices.fetchDueCards(
        limit: limit,
        collectionId: collectionId,
      );
      final localService = GeneralLocalService();
      await localService.clearBox<BaseCardEntity>(K_DUE_CARDS_BOX);
      for (var card in result) {
        await localService.add<BaseCardEntity>(K_DUE_CARDS_BOX, card);
      }
      return result;
    } else {
      // Offline
      return GeneralLocalService().getAll(K_DUE_CARDS_BOX);
    }
  }

  @override
  Future<void> submitRating(BaseCardEntity card, int quality) async {
    await appServices.submitRating(card, quality);
  }
}
