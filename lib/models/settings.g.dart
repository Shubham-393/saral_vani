// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsAdapter extends TypeAdapter<Settings> {
  @override
  final int typeId = 1;

  @override
  Settings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Settings(
      isDarkMode: fields[0] as bool,
      primaryLanguage: fields[1] as String,
      secondaryLanguage: fields[2] as String,
      textSize: fields[3] as double,
      captionOpacity: fields[4] as double,
      enableVibration: fields[5] as bool,
      enableISLAnimations: fields[6] as bool,
      enableSoundAlerts: fields[7] as bool,
      enableSystemOverlay: fields[8] as bool,
      autoSaveTranscripts: fields[9] as bool,
      maxTranscriptHistory: fields[10] as int,
      highContrastMode: fields[11] as bool,
      screenReaderEnabled: fields[12] as bool,
      hapticFeedbackEnabled: fields[13] as bool,
      speechConfidenceThreshold: fields[14] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Settings obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.isDarkMode)
      ..writeByte(1)
      ..write(obj.primaryLanguage)
      ..writeByte(2)
      ..write(obj.secondaryLanguage)
      ..writeByte(3)
      ..write(obj.textSize)
      ..writeByte(4)
      ..write(obj.captionOpacity)
      ..writeByte(5)
      ..write(obj.enableVibration)
      ..writeByte(6)
      ..write(obj.enableISLAnimations)
      ..writeByte(7)
      ..write(obj.enableSoundAlerts)
      ..writeByte(8)
      ..write(obj.enableSystemOverlay)
      ..writeByte(9)
      ..write(obj.autoSaveTranscripts)
      ..writeByte(10)
      ..write(obj.maxTranscriptHistory)
      ..writeByte(11)
      ..write(obj.highContrastMode)
      ..writeByte(12)
      ..write(obj.screenReaderEnabled)
      ..writeByte(13)
      ..write(obj.hapticFeedbackEnabled)
      ..writeByte(14)
      ..write(obj.speechConfidenceThreshold);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
