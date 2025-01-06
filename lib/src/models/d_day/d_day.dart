import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'd_day.freezed.dart';
part 'd_day.g.dart';

@freezed
@HiveType(typeId: 10)
class DDay with _$DDay {
  const factory DDay({
    @HiveField(0) String? id,
    @HiveField(1) required String goalTitle,
    @HiveField(2) required int goalDate,
    @HiveField(3) required String color,
  }) = _DDay;

  factory DDay.fromJson(Map<String, dynamic> json) => _$DDayFromJson(json);
}
