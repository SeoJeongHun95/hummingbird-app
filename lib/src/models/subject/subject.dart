import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'subject.freezed.dart';
part 'subject.g.dart';

@freezed
@HiveType(typeId: 22)
class Subject with _$Subject {
  factory Subject({
    @HiveField(0, defaultValue: null) String? subjectId,
    @HiveField(1) required String title,
    @HiveField(2) required String color,
    @HiveField(3) required int order,
  }) = _Subject;

  factory Subject.fromJson(Map<String, dynamic> json) =>
      _$SubjectFromJson(json);
}
