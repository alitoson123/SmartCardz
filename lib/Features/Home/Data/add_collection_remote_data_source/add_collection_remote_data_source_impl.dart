import 'package:smart_cards/Features/Home/Data/Models/collection_model.dart';
import 'package:smart_cards/Features/Home/Data/add_collection_remote_data_source/add_collection_remote_data_source.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';
import 'package:smart_cards/core/services/app_services/app_services.dart';

class AddCollectionRemoteDataSourceImpl extends AddCollectionRemoteDataSource {
  final AppServices appServices;

  AddCollectionRemoteDataSourceImpl({required this.appServices});

  @override
  Future<CollectionModel> addCollection({
    required String collectionName,
  }) async {
 var result =   await appServices.createNewCollection(
      collectionName: collectionName,
    );
    return result;
  }

  @override
  Future<CollectionEntity> getCollection({required String collectionName}) {
    // TODO: implement getCollection
    throw UnimplementedError();
  }
}
