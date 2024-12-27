// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TokensModelAdapter extends TypeAdapter<_$TokenModelImpl> {
  @override
  final int typeId = 1;

  @override
  _$TokenModelImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$TokenModelImpl(
      accessToken: fields[0] as String?,
      refreshToken: fields[1] as String?,
      expiresAt: fields[2] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, _$TokenModelImpl obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.accessToken)
      ..writeByte(1)
      ..write(obj.refreshToken)
      ..writeByte(2)
      ..write(obj.expiresAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TokensModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
