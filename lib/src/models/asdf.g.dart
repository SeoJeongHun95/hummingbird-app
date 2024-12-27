// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asdf.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AsdfAdapter extends TypeAdapter<Asdf> {
  @override
  final int typeId = 0;

  @override
  Asdf read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Asdf(
      a: fields[0] as String,
      b: fields[1] as int,
      c: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Asdf obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.a)
      ..writeByte(1)
      ..write(obj.b)
      ..writeByte(2)
      ..write(obj.c);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AsdfAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
