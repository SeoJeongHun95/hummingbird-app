import 'package:freezed_annotation/freezed_annotation.dart';

import '../subject/subject.dart';

part 'study_record.freezed.dart';
part 'study_record.g.dart';

@freezed
class StudyRecord with _$StudyRecord {
  factory StudyRecord({
    required Subject subject,
    required int startAt,
    required int endAt,
    required int elapsedTime,
    required int breakTime,
  }) = _StudyRecord;

  factory StudyRecord.fromJson(Map<String, dynamic> json) =>
      _$StudyRecordFromJson(json);
}
