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
    @HiveField(1) required int startAt,
    @HiveField(2) required int endAt,
    @HiveField(3) required int elapsedTime,
    @HiveField(4) required int breakTime,
  }) = _StudyRecord;

  factory StudyRecord.fromJson(Map<String, dynamic> json) =>
      _$StudyRecordFromJson(json);
}
