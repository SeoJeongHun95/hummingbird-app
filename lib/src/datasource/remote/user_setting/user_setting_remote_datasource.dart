import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../models/setting/user_setting.dart';

class UserSettingRemoteDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get _userId => FirebaseAuth.instance.currentUser!.uid;

  DocumentReference get _userUserSettingDoc =>
      _firestore.collection('userSetting').doc(_userId);

  Future<void> addUserSetting(UserSetting userSetting) async {
    await _userUserSettingDoc.set(
      {_userId: userSetting.toJson()},
      SetOptions(merge: true),
    );
  }

  Future<UserSetting> fetchUserSetting() async {
    var snapshot = await _userUserSettingDoc.get();

    if (!snapshot.exists) {
      final nickName = 'User #${_userId.substring(0, 3)}';
      final userSetting = UserSetting(nickname: nickName);
      await addUserSetting(userSetting);

      return userSetting;
    }

    final data = snapshot.data() as Map<String, dynamic>;
    if (data.isEmpty) {
      final nickName = 'User #${_userId.substring(0, 3)}';
      final userSetting = UserSetting(nickname: nickName);

      await addUserSetting(userSetting);

      return userSetting;
    }
    return data.entries.map((e) {
      final userSetting = UserSetting.fromJson(e.value as Map<String, dynamic>);
      return userSetting;
    }).first;
  }

  Future<void> updateUserSetting(UserSetting updatedUserSetting) async {
    await _userUserSettingDoc.update({_userId: updatedUserSetting.toJson()});
  }

  Future<void> updateProfileImg(File profileImg) async {
    return;
  }
}
