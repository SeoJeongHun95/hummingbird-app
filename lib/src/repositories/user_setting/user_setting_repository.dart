import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/const/box_keys.dart';
import '../../datasource/local/user_setting/user_setting_local_datasource.dart';
import '../../models/setting/user_setting.dart';

part 'user_setting_repository.g.dart';

@riverpod
UserSettingRepository userSettingRepository(Ref ref) {
  final box = Hive.box<UserSetting>(BoxKeys.userSettingBoxKey);
  final localDatasource = UserSettingLocalDatasource(box);

  return UserSettingRepository(localDatasource);
}

class UserSettingRepository {
  UserSettingRepository(this._localDatasource);
  final UserSettingLocalDatasource _localDatasource;

  Future<void> addUserSetting(UserSetting userSetting) async {
    await _localDatasource.addUserSetting(userSetting);
  }

  Future<UserSetting> getUserSetting() async {
    return _localDatasource.getUserSetting();
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
    await _localDatasource.updateUserSetting(updatedUserSetting);
  }
}
