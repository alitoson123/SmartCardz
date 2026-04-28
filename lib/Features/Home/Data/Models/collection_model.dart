import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';

class CollectionModel extends CollectionEntity {
  CollectionModel({
    required super.collectionName,
    required super.cards_count,
    required super.collection_id,
    required super.owner_id,
  });

  // from firestore doc
  factory CollectionModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CollectionModel(
      owner_id: data['owner_id'] ?? '',
      collectionName: data['collection_name'] ?? '',
      cards_count: data['cards_count'] ?? 0,
      collection_id: data['id'],
    );
  }

  // to map
  Map<String, dynamic> toMap() {
    return {
      'collection_name': collectionName,
      'cards_count': cards_count,
      'owner_id': owner_id,
      'created_at': FieldValue.serverTimestamp(),
    };
  }

  // CopyWith method to update values immutably
  @override
  CollectionModel copyWith({
    String? collectionName,
    int? cards_count,
    String? collection_id,
    String? owner_id,
  }) {
    return CollectionModel(
      collectionName: collectionName ?? this.collectionName,
      cards_count: cards_count ?? this.cards_count,
      collection_id: collection_id ?? this.collection_id,
      owner_id: owner_id ?? this.owner_id,
    );
  }

  factory CollectionModel.fromEntity(CollectionEntity collection) {
    return CollectionModel(
      owner_id: collection.owner_id,
      collectionName: collection.collectionName,
      cards_count: collection.cards_count,
      collection_id: collection.collection_id,
    );
  }
}
