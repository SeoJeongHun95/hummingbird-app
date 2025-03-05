import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_setting.freezed.dart';
part 'user_setting.g.dart';

@freezed
class UserSetting with _$UserSetting {
  const factory UserSetting({
    String? nickname,
    String? birthDate,
    String? mbti,
    String? profileImgUrl,
  }) = _UserSetting;

  factory UserSetting.fromJson(Map<String, dynamic> json) =>
      _$UserSettingFromJson(json);
}
