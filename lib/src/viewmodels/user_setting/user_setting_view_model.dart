import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:StudyDuck/src/services/storage_service.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:image_picker/image_picker.dart';

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

  Future<void> updateProfileImg(XFile imageFile) async {
    if (imageFile == null) return;

    final imgFile = File(imageFile.path);
    final storageService = ref.read(storageServiceProvider);
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      throw Exception('사용자 인증이 필요합니다');
    }

    try {
      final downloadUrl = await storageService.uploadProfileImage(imgFile, uid);
      await updateUserSetting(updatedImgUrl: downloadUrl);
    } catch (e) {
      throw Exception('프로필 이미지 업데이트 실패: $e');
    }
  }
}
