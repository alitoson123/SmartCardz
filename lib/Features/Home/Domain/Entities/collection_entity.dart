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
}
