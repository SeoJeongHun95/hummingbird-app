import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'study_record.freezed.dart';
part 'study_record.g.dart';

@freezed
@HiveType(typeId: 21)
class StudyRecord with _$StudyRecord {
  factory StudyRecord({
    @HiveField(0) required String title,
    @HiveField(1) required String color,
    @HiveField(2) required int order,
    @HiveField(3) int? startAt,
    @HiveField(4) int? endAt,
    @HiveField(5) @Default(0) int elapsedTime,
    @HiveField(6) @Default(0) int breakTime,
  }) = _StudyRecord;

  factory StudyRecord.fromJson(Map<String, dynamic> json) =>
      _$StudyRecordFromJson(json);
}
