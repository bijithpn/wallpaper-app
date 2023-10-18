// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_type_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteAdapter extends TypeAdapter<Favorite> {
  @override
  final int typeId = 1;

  @override
  Favorite read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Favorite(
      id: fields[0] as int,
      photographer: fields[1] as String,
      photographerUrl: fields[2] as String,
      avgColor: fields[3] as String,
      imgPortrait: fields[4] as String,
      imgSmall: fields[5] as String,
      width: fields[6] as String,
      height: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Favorite obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.photographer)
      ..writeByte(2)
      ..write(obj.photographerUrl)
      ..writeByte(3)
      ..write(obj.avgColor)
      ..writeByte(4)
      ..write(obj.imgPortrait)
      ..writeByte(5)
      ..write(obj.imgSmall)
      ..writeByte(6)
      ..write(obj.width)
      ..writeByte(7)
      ..write(obj.height);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
