import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'subject.freezed.dart';
part 'subject.g.dart';

@freezed
@HiveType(typeId: 7) // HiveType 추가
class Subject with _$Subject {
  factory Subject({
    @HiveField(0) required String title,
    @HiveField(1) required String color,
    @HiveField(2) required int order,
  }) = _Subject;

  factory Subject.fromJson(Map<String, dynamic> json) =>
      _$SubjectFromJson(json);
}
