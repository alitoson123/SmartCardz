// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CollectionModelAdapter extends TypeAdapter<CollectionModel> {
  @override
  final int typeId = 0;

  @override
  CollectionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CollectionModel(
      owner_id: fields[0] as String,
      collectionName: fields[1] as String,
      cards_count: fields[2] as int,
      collection_id: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CollectionModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.owner_id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CollectionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
