import 'package:freezed_annotation/freezed_annotation.dart';

part 'study_record.freezed.dart';
part 'study_record.g.dart';

@freezed
class StudyRecord with _$StudyRecord {
  factory StudyRecord({
    required String subjectId,
    required String title,
    required String color,
    required String dateKey,
    int? startAt,
    int? endAt,
    @Default(0) int elapsedTime,
    @Default(0) int breakTime,
  }) = _StudyRecord;

  factory StudyRecord.fromJson(Map<String, dynamic> json) =>
      _$StudyRecordFromJson(json);
}
