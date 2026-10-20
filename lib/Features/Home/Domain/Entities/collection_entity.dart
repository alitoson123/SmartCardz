import 'package:smart_cards/Features/Home/Domain/Entities/home_item_entity.dart';

class CollectionEntity implements HomeItemEntity {
  final String collectionName;
  final int cards_count;
  final String collection_id;
  final String owner_id;
  final String? folder_id;
  @override
  final DateTime createdAt;

  const CollectionEntity({
    required this.owner_id,
    required this.collection_id,
    required this.collectionName,
    required this.cards_count,
    this.folder_id,
    required this.createdAt,
  });

  CollectionEntity copyWith({
    String? collectionName,
    int? cards_count,
    String? collection_id,
    String? owner_id,
    String? folder_id,
    DateTime? createdAt,
  }) {
    return CollectionEntity(
      collectionName: collectionName ?? this.collectionName,
      cards_count: cards_count ?? this.cards_count,
      collection_id: collection_id ?? this.collection_id,
      owner_id: owner_id ?? this.owner_id,
      folder_id: folder_id ?? this.folder_id,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
