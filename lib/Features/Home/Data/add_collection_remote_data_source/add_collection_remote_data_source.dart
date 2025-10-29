import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';

abstract class AddCollectionRemoteDataSource {
  Future<CollectionEntity> addCollection({required String collectionName});
  Future<CollectionEntity> getCollection({required String collectionName});
}
