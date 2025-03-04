import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../datasource/remote/user_setting/user_setting_remote_datasource.dart';
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

  Future<void> updateUserSetting(UserSetting updatedUserSetting) async {
    await _remoteDatasource.updateUserSetting(updatedUserSetting);
  }

  Future<void> updateProfileImg(File profileImg) async {
    await _remoteDatasource.updateProfileImg(profileImg);
  }
}
