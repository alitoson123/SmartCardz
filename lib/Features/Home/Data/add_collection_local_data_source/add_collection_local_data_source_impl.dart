import 'package:smart_cards/Features/Home/Data/add_collection_local_data_source/add_collection_local_data_source.dart';
import 'package:smart_cards/constant.dart';
import 'package:smart_cards/core/services/Local_service/general_local_service.dart';

class AddCollectionLocalDataSourceImpl extends AddCollectionLocalDataSource {
  final GeneralLocalService generalLocalService;

  AddCollectionLocalDataSourceImpl({required this.generalLocalService});
  @override
  void addCollection({required String collectionName}) {
    generalLocalService.add(K_COLLECTION_BOX, collectionName);
  }
}
