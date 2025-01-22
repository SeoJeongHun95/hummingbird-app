import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/const/box_keys.dart';
import '../../datasource/local/user_setting/user_setting_local_datasource.dart';
import '../../datasource/remote/user/get_profile_api.dart';
import '../../datasource/remote/user/update_profile_api.dart';
import '../../datasource/remote/user/user_setting_remote_datasource.dart';
import '../../models/setting/user_setting.dart';

part 'user_setting_repository.g.dart';

@riverpod
UserSettingRepository userSettingRepository(Ref ref) {
  final box = Hive.box<UserSetting>(BoxKeys.userSettingBoxKey);
  final localDatasource = UserSettingLocalDatasource(box);
  final getProfileApi = ref.watch(getProfileApiProvider);
  final userProfileApi = ref.watch(updateProfileApiProvider);
  final remoteDatasource = UserSettingRemoteDatasource(
    getProfileApi: getProfileApi,
    updateProfileApi: userProfileApi,
  );

  return UserSettingRepository(localDatasource, remoteDatasource);
}

class UserSettingRepository {
  UserSettingRepository(this._localDatasource, this._remoteDatasource);
  final UserSettingLocalDatasource _localDatasource;
  final UserSettingRemoteDatasource _remoteDatasource;

  Future<void> addUserSetting(UserSetting userSetting) async {
    await _localDatasource.addUserSetting(userSetting);
  }

  Future<UserSetting> getUserSetting(bool isConnected) async {
    if (isConnected) {
      final dto = await _remoteDatasource.getUserSetting();
      final fetchedUserSetting = profileDtoToUserSetting(dto);
      if (fetchedUserSetting.nickname == null &&
          fetchedUserSetting.birthDate == null) {
        return _localDatasource.getUserSetting();
      }
      await _localDatasource.addUserSetting(fetchedUserSetting);

      return fetchedUserSetting;
    }

    return _localDatasource.getUserSetting();
  }

  Future<void> fetchUserSetting() async {
    final dto = await _remoteDatasource.getUserSetting();
    final fetchedUser = profileDtoToUserSetting(dto);
    final currentUserSetting = _localDatasource.getUserSetting();
    addUserSetting(
      currentUserSetting.copyWith(
        nickname: fetchedUser.nickname ?? currentUserSetting.nickname,
        birthDate: fetchedUser.birthDate ?? currentUserSetting.birthDate,
      ),
    );
  }

  Future<void> updateUserSetting(UserSetting updatedUserSetting) async {
    await _remoteDatasource
        .updateUserSetting(localModelToDto(updatedUserSetting));
    await _localDatasource.updateUserSetting(updatedUserSetting);
  }

  UpdateProfileApiReqDto localModelToDto(UserSetting updatedUserSetting) {
    return UpdateProfileApiReqDto(
      nickname: updatedUserSetting.nickname,
      birthDate: updatedUserSetting.birthDate,
    );
  }

  UserSetting profileDtoToUserSetting(GetProfileApiResDto dto) {
    return UserSetting(nickname: dto.nickname, birthDate: dto.birthDate);
  }
}
