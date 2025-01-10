import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import '../subject/subject.dart';

part 'study_record.freezed.dart';
part 'study_record.g.dart';

@freezed
@HiveType(typeId: 21)
class StudyRecord with _$StudyRecord {
  factory StudyRecord({
    @HiveField(0) required Subject subject,
    @HiveField(1) int? startAt,
    @HiveField(2) int? endAt,
    @HiveField(3) @Default(0) int elapsedTime,
    @HiveField(4) @Default(0) int breakTime,
  }) = _StudyRecord;

  factory StudyRecord.fromJson(Map<String, dynamic> json) =>
      _$StudyRecordFromJson(json);
}
