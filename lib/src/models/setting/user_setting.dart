import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'user_setting.freezed.dart';
part 'user_setting.g.dart';

@freezed
@HiveType(typeId: 13)
class UserSetting with _$UserSetting {
  const factory UserSetting({
    @HiveField(0) int? userId,
    @HiveField(1) String? nickname,
    @HiveField(2) String? birthDate,
  }) = _UserSetting;

  factory UserSetting.fromJson(Map<String, dynamic> json) =>
      _$UserSettingFromJson(json);
}
