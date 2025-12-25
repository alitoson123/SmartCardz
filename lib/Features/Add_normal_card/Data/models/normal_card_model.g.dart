// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'normal_card_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NormalCardModelAdapter extends TypeAdapter<NormalCardModel> {
  @override
  final int typeId = 3;

  @override
  NormalCardModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NormalCardModel(
      id: fields[0] as String,
      repetition: fields[1] as int,
      easiness: fields[2] as double,
      interval: fields[3] as int,
      nextReview: fields[4] as Timestamp?,
      frontSide: fields[5] as String,
      backSide: fields[6] as String,
      frontImageUrl: fields[7] as String,
      backImageUrl: fields[8] as String,
      collectionId: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NormalCardModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.repetition)
      ..writeByte(2)
      ..write(obj.easiness)
      ..writeByte(3)
      ..write(obj.interval)
      ..writeByte(4)
      ..write(obj.nextReview)
      ..writeByte(5)
      ..write(obj.frontSide)
      ..writeByte(6)
      ..write(obj.backSide)
      ..writeByte(7)
      ..write(obj.frontImageUrl)
      ..writeByte(8)
      ..write(obj.backImageUrl)
      ..writeByte(9)
      ..write(obj.collectionId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NormalCardModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
