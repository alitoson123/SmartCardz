class CollectionEntity {
  final String collectionName;
  final int cards_count;
  final String collection_id;
  final DateTime? created_at;

  const CollectionEntity({
    required this.collection_id,
    required this.collectionName,
    required this.cards_count,
    this.created_at,
  });
}
