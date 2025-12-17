// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card__with_AI_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CardWithAIModelAdapter extends TypeAdapter<CardWithAIModel> {
  @override
  final int typeId = 0;

  @override
  CardWithAIModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CardWithAIModel(
      id: fields[0] as String,
      repetition: fields[1] as int,
      easiness: fields[2] as double,
      interval: fields[3] as int,
      nextReview: fields[4] as Timestamp?,
      word: fields[5] as String,
      type: fields[6] as String,
      definition: fields[7] as String,
      example: fields[8] as String,
      imageBase64: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CardWithAIModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.repetition)
      ..writeByte(2)
      ..write(obj.easiness)
      ..writeByte(3)
      ..write(obj.interval)
      ..writeByte(4)
      ..write(obj.nextReview);
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
