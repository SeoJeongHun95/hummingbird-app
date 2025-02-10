import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'app_setting.freezed.dart';
part 'app_setting.g.dart';

@freezed
@HiveType(typeId: 12)
class AppSetting with _$AppSetting {
  const factory AppSetting({
    @HiveField(0) @Default('227C9D') String color,
    @HiveField(1) @Default(4) int fontSize,
    @HiveField(2) @Default('ko') String language,
    @HiveField(3) @Default(true) bool isFirstInstalled,
    @HiveField(4) @Default(false) bool autoFocusMode,
  }) = _AppSetting;

  factory AppSetting.fromJson(Map<String, dynamic> json) =>
      _$AppSettingFromJson(json);
}
