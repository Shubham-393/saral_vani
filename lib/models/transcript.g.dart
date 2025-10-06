// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transcript.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TranscriptAdapter extends TypeAdapter<Transcript> {
  @override
  final int typeId = 0;

  @override
  Transcript read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transcript(
      id: fields[0] as String,
      originalText: fields[1] as String,
      simplifiedText: fields[2] as String,
      timestamp: fields[3] as DateTime,
      language: fields[4] as String,
      confidence: fields[5] as double,
      hasISLAnimation: fields[6] as bool,
      islAnimationPath: fields[7] as String?,
      tags: (fields[8] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Transcript obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.originalText)
      ..writeByte(2)
      ..write(obj.simplifiedText)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.language)
      ..writeByte(5)
      ..write(obj.confidence)
      ..writeByte(6)
      ..write(obj.hasISLAnimation)
      ..writeByte(7)
      ..write(obj.islAnimationPath)
      ..writeByte(8)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranscriptAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
