import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';
import 'package:smart_cards/core/Data/collection_remote_data_source/collection_remote_data_source.dart';
import 'package:smart_cards/core/services/app_services/app_services.dart';

class CollectionRemoteDataSourceImpl extends CollectionRemoteDataSource {
  final AppServices appServices;

  CollectionRemoteDataSourceImpl({required this.appServices});

  @override
  Future<List<CollectionEntity>> getCollections(

  ) async {
   var result = await appServices.fetchUserCollections();

    return result;
  }
}
