// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'd_day.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DDayAdapter extends TypeAdapter<DDay> {
  @override
  final int typeId = 0;

  @override
  DDay read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DDay(
      goalTitle: fields[0] as String,
      goalDate: fields[1] as String,
      createDate: fields[2] as String,
      color: fields[3] as String,
      state: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DDay obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.goalTitle)
      ..writeByte(1)
      ..write(obj.goalDate)
      ..writeByte(2)
      ..write(obj.createDate)
      ..writeByte(3)
      ..write(obj.color)
      ..writeByte(4)
      ..write(obj.state);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DDayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DDayImpl _$$DDayImplFromJson(Map<String, dynamic> json) => _$DDayImpl(
      goalTitle: json['goalTitle'] as String,
      goalDate: json['goalDate'] as String,
      createDate: json['createDate'] as String,
      color: json['color'] as String,
      state: (json['state'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$DDayImplToJson(_$DDayImpl instance) =>
    <String, dynamic>{
      'goalTitle': instance.goalTitle,
      'goalDate': instance.goalDate,
      'createDate': instance.createDate,
      'color': instance.color,
      'state': instance.state,
    };
