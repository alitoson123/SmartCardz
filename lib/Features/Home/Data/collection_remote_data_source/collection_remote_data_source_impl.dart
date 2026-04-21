import 'package:smart_cards/Features/Home/Data/collection_remote_data_source/collection_remote_data_source.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';
import 'package:smart_cards/core/services/app_services/collection_service.dart';

class CollectionRemoteDataSourceImpl extends CollectionRemoteDataSource {
  final CollectionService collectionService;

  CollectionRemoteDataSourceImpl({required this.collectionService});

  // add collection
  @override
  Future<CollectionEntity> addCollection({
    required String collectionName,
  }) async {
    var result = await collectionService.createNewCollection(
      collectionName: collectionName,
    );
    return result;
  }

  // get collections
  @override
  Future<List<CollectionEntity>> getCollections() async {
    var result = await collectionService.fetchUserCollections();

    return result;
  }
}
