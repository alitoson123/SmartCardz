class CollectionEntity {
  final String collectionName;
  final int cards_count;
  final String collection_id;
  final String owner_id;

  const CollectionEntity({
    required this.owner_id,
    required this.collection_id,
    required this.collectionName,
    required this.cards_count,
  });

  CollectionEntity copyWith({
    String? collectionName,
    int? cards_count,
    String? collection_id,
    String? owner_id,
  }) {
    return CollectionEntity(
      collectionName: collectionName ?? this.collectionName,
      cards_count: cards_count ?? this.cards_count,
      collection_id: collection_id ?? this.collection_id,
      owner_id: owner_id ?? this.owner_id,
    );
  }
}
