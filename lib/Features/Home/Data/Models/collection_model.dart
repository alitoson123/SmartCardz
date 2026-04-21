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
}
