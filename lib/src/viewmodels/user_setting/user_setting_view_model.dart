import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/setting/user_setting.dart';
import '../../repositories/user_setting/user_setting_repository.dart';

part 'user_setting_view_model.g.dart';

@Riverpod(keepAlive: true)
class UserSettingViewModel extends _$UserSettingViewModel {
  late UserSettingRepository userSettingRepository;
  @override
  Future<UserSetting> build() async {
    final isConnected = await ref.watch(networkStateProvider.future);
    userSettingRepository = ref.watch(userSettingRepositoryProvider);

    return await userSettingRepository.getUserSetting(isConnected);
  }

  Future<void> addUserSetting(
      {required String nickName, String? birthDate}) async {
    final isConnected = await ref.read(networkStateProvider.future);

    state = await AsyncValue.guard(() async {
      final currentUserSetting =
          await userSettingRepository.getUserSetting(isConnected);
      final userSetting = UserSetting(
        userId: currentUserSetting.userId,
        nickname: nickName,
        birthDate: birthDate ?? currentUserSetting.birthDate,
      );
      await userSettingRepository.addUserSetting(userSetting);

      return userSetting;
    });
  }

  Future<void> updateUserSetting(
      {String? updatedNickName, String? updatedAge}) async {
    final isConnected = await ref.read(networkStateProvider.future);

    state = await AsyncValue.guard(() async {
      final currentUserSetting =
          await userSettingRepository.getUserSetting(isConnected);
      final updatedUserSetting = UserSetting(
        userId: currentUserSetting.userId,
        nickname: updatedNickName ?? currentUserSetting.nickname,
        birthDate: updatedAge ?? currentUserSetting.birthDate,
      );
      await userSettingRepository.updateUserSetting(updatedUserSetting);

      return updatedUserSetting;
    });
  }

  Future<void> addUserId(int userId) async {
    final isConnected = await ref.read(networkStateProvider.future);

    final currentUserSetting =
        await userSettingRepository.getUserSetting(isConnected);
    final addedIdUserSetting = UserSetting(
      userId: userId,
      nickname: currentUserSetting.nickname,
      birthDate: currentUserSetting.birthDate,
    );
    await userSettingRepository.addUserSetting(addedIdUserSetting);
  }
}
