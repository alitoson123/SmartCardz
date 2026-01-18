import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';
part 'collection_model.g.dart';

@HiveType(typeId: 1)
class CollectionModel extends CollectionEntity with HiveObjectMixin {
  @HiveField(0)
  final String owner_id;

  @HiveField(1)
  @override
  final String collectionName;
  @HiveField(2)
  @override
  final int cards_count;
  @HiveField(3)
  @override
  final String collection_id;

  @HiveField(4)
  @override
  final DateTime? created_at;

  CollectionModel({
    required this.collectionName,
    required this.cards_count,
    required this.collection_id,
    required this.owner_id,
    this.created_at,
  }) : super(
         collectionName: collectionName,
         cards_count: cards_count,
         collection_id: collection_id,
         created_at: created_at,
       );

  /// ✅ لتحويل الكائن إلى Map قبل الحفظ في Firestore
  Map<String, dynamic> toMap() {
    return {
      'collection_name': collectionName,
      'cards_count': cards_count,
      'owner_id': owner_id,
      'created_at': FieldValue.serverTimestamp(),
    };
  }

  /// ✅ لتحويل document من Firestore إلى كائن
  factory CollectionModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CollectionModel(
      owner_id: data['owner_id'] ?? '',
      collectionName: data['collection_name'] ?? '',
      cards_count: data['cards_count'] ?? 0,
      collection_id: doc.id,
      created_at: data['created_at'] is Timestamp
          ? (data['created_at'] as Timestamp).toDate()
          : null,
    );
  }
}
