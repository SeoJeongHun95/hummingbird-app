import 'package:StudyDuck/src/datasource/remote/user_setting/user_setting_remote_datasourcedart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/setting/user_setting.dart';

part 'user_setting_repository.g.dart';

@riverpod
UserSettingRepository userSettingRepository(Ref ref) {
  return UserSettingRepository(UserSettingRemoteDatasource());
}

class UserSettingRepository {
  UserSettingRepository(this._remoteDatasource);
  //final UserSettingLocalDatasource _localDatasource;
  final UserSettingRemoteDatasource _remoteDatasource;

  Future<UserSetting> fetchUserSetting() async {
    return await _remoteDatasource.fetchUserSetting();
  }

  // Future<void> fetchUserSetting() async {
  //   final dto = await _remoteDatasource.getUserSetting();
  //   final fetchedUser = profileDtoToUserSetting(dto);
  //   final currentUserSetting = _localDatasource.getUserSetting();
  //   addUserSetting(
  //     currentUserSetting.copyWith(
  //       nickname: fetchedUser.nickname ?? currentUserSetting.nickname,
  //       birthDate: fetchedUser.birthDate ?? currentUserSetting.birthDate,
  //     ),
  //   );
  // }

  Future<void> updateUserSetting(UserSetting updatedUserSetting) async {
    await _remoteDatasource.updateUserSetting(updatedUserSetting);
  }
}
