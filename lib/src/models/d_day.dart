import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'd_day.freezed.dart';
part 'd_day.g.dart';

@freezed
@HiveType(typeId: 0)
class DDay with _$DDay {
  const factory DDay({
    @HiveField(0) required String goalTitle,
    @HiveField(1) required String goalDate,
    @HiveField(2) required String createDate,
    @HiveField(3) required String color,
    @HiveField(4) @Default(0) int state,
  }) = _DDay;

  factory DDay.fromJson(Map<String, dynamic> json) => _$DDayFromJson(json);
}
