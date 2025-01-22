import 'dart:math';

import 'package:hive/hive.dart';

import '../../../models/setting/user_setting.dart';

class UserSettingLocalDatasource {
  UserSettingLocalDatasource(this._box);
  final Box<UserSetting> _box;

  String get key => 'userSetting';

  Future<void> addUserSetting(UserSetting userSetting) async {
    await _box.put(key, userSetting);
  }

  UserSetting getUserSetting() {
    return _box.get(key) ??
        UserSetting(
          nickname: '유저 #${Random().nextInt(300).toString().padLeft(3, '0')} ',
        );
  }

  Future<void> updateUserSetting(UserSetting updatedUserSetting) async {
    await _box.put(key, updatedUserSetting);
  }
}
