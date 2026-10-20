import 'package:smart_cards/Features/Home/Domain/Entities/home_item_entity.dart';

class FolderEntity implements HomeItemEntity {
  final String id;
  final String name;
  final String ownerId;
  @override
  final DateTime createdAt;

  const FolderEntity({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.createdAt,
  });

  FolderEntity copyWith({
    String? id,
    String? name,
    String? ownerId,
    DateTime? createdAt,
  }) {
    return FolderEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
