// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_type_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingAdapter extends TypeAdapter<Setting> {
  @override
  final int typeId = 1;

  @override
  Setting read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Setting(
      isDark: fields[0] as bool,
      onWifi: fields[1] as bool,
      onCharging: fields[2] as bool,
      onidle: fields[3] as bool,
      screen: fields[4] as int,
      interval: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Setting obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.isDark)
      ..writeByte(1)
      ..write(obj.onWifi)
      ..writeByte(2)
      ..write(obj.onCharging)
      ..writeByte(3)
      ..write(obj.onidle)
      ..writeByte(4)
      ..write(obj.screen)
      ..writeByte(5)
      ..write(obj.interval);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
