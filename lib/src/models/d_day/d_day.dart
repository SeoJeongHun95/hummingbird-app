import 'package:freezed_annotation/freezed_annotation.dart';

part 'd_day.freezed.dart';
part 'd_day.g.dart';

@freezed
class DDay with _$DDay {
  const factory DDay({
    @JsonKey(name: 'id') String? ddayId,
    required String title,
    required String color,
    required int targetDatetime,
  }) = _DDay;

  factory DDay.fromJson(Map<String, dynamic> json) => _$DDayFromJson(json);
}
