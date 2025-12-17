import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';

abstract class CollectionRemoteDataSource {
  Future<CollectionEntity> addCollection({required String collectionName});
  Future<List<CollectionEntity>> getCollections();
}
