import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/setting/user_setting.dart';
import '../../repositories/user_setting/user_setting_repository.dart';

part 'user_setting_view_model.g.dart';

@riverpod
class UserSettingViewModel extends _$UserSettingViewModel {
  late final UserSettingRepository repository;
  @override
  UserSetting build() {
    repository = ref.watch(userSettingRepositoryProvider);

    return repository.getUserSetting();
  }

  Future<void> addUserSetting(
      {required String nickName, String? birthDate}) async {
    final currentUserSetting = repository.getUserSetting();
    final userSetting = UserSetting(
      userId: currentUserSetting.userId,
      nickname: nickName,
      birthDate: birthDate ?? currentUserSetting.birthDate,
    );
    await repository.addUserSetting(userSetting);

    state = userSetting;
  }

  Future<void> updateUserSetting(
      {String? updatedNickName, String? updatedAge}) async {
    final currentUserSetting = repository.getUserSetting();
    final updatedUserSetting = UserSetting(
      userId: currentUserSetting.userId,
      nickname: updatedNickName ?? currentUserSetting.nickname,
      birthDate: updatedAge ?? currentUserSetting.birthDate,
    );
    await repository.updateUserSetting(updatedUserSetting);

    state = updatedUserSetting;
  }

  Future<void> addUserId(int userId) async {
    final currentUserSetting = repository.getUserSetting();
    final addedIdUserSetting = UserSetting(
      userId: userId,
      nickname: currentUserSetting.nickname,
      birthDate: currentUserSetting.birthDate,
    );
    await repository.addUserSetting(addedIdUserSetting);
  }
}
