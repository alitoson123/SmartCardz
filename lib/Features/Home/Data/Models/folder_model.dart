import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/folder_entity.dart';

class FolderModel extends FolderEntity {
  const FolderModel({
    required super.id,
    required super.name,
    required super.ownerId,
    required super.createdAt,
  });

  factory FolderModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FolderModel(
      id: data['id'],
      name: data['name'] ?? '',
      ownerId: data['owner_id'] ?? '',
      createdAt: (data['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'owner_id': ownerId,
    
    };
  }

  @override
  FolderModel copyWith({
    String? id,
    String? name,
    String? ownerId,
    DateTime? createdAt,
  }) {
    return FolderModel(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory FolderModel.fromEntity(FolderEntity folder) {
    return FolderModel(
      id: folder.id,
      name: folder.name,
      ownerId: folder.ownerId,
      createdAt: folder.createdAt,
    );
  }
}
