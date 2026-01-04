// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card__with_AI_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CardWithAIModelAdapter extends TypeAdapter<CardWithAIModel> {
  @override
  final int typeId = 2;

  @override
  CardWithAIModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CardWithAIModel(
      id: fields[0] as String,
      word: fields[5] as String,
      type: (fields[6] as List).cast<dynamic>(),
      definition: fields[7] as String,
      example: (fields[8] as List).cast<dynamic>(),
      image_url: fields[9] as String,
      repetition: fields[1] as int,
      easiness: fields[2] as double,
      interval: fields[3] as int,
      nextReview: fields[4] as Timestamp?,
      collectionId: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CardWithAIModel obj) {
    writer
      ..writeByte(11)
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
      ..writeByte(10)
      ..write(obj.collectionId)
      ..writeByte(5)
      ..write(obj.word)
      ..writeByte(6)
      ..write(obj.type)
      ..writeByte(7)
      ..write(obj.definition)
      ..writeByte(8)
      ..write(obj.example)
      ..writeByte(9)
      ..write(obj.image_url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardWithAIModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
