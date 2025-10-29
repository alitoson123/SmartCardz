import 'package:smart_cards/Features/Home/Data/Models/collection_model.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';

abstract class AddCollectionRemoteDataSource {
  Future<CollectionModel> addCollection({required String collectionName});
  Future<CollectionEntity> getCollection({required String collectionName});
}
