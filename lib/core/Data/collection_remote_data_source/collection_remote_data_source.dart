import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';

abstract class CollectionRemoteDataSource {
  Future<List<CollectionEntity>> getCollections();
}
