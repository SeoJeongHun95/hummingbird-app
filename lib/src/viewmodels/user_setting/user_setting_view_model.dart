import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/setting/user_setting.dart';
import '../../repositories/user_setting/user_setting_repository.dart';

part 'user_setting_view_model.g.dart';

@Riverpod(keepAlive: true)
class UserSettingViewModel extends _$UserSettingViewModel {
  late UserSettingRepository userSettingRepository;
  @override
  Future<UserSetting> build() async {
    userSettingRepository = ref.watch(userSettingRepositoryProvider);

    return await userSettingRepository.fetchUserSetting();
  }

  Future<void> updateUserSetting(
      {String? updatedNickName,
      String? updatedAge,
      String? updatedMbti,
      String? updatedImgUrl}) async {
    state = await AsyncValue.guard(() async {
      final currentUserSetting = await userSettingRepository.fetchUserSetting();
      final updatedUserSetting = UserSetting(
        nickname: updatedNickName ?? currentUserSetting.nickname,
        birthDate: updatedAge ?? currentUserSetting.birthDate,
        mbti: updatedMbti ?? currentUserSetting.mbti,
        profileImgUrl: updatedImgUrl ?? currentUserSetting.profileImgUrl,
      );
      await userSettingRepository.updateUserSetting(updatedUserSetting);

      return updatedUserSetting;
    });
  }
}
