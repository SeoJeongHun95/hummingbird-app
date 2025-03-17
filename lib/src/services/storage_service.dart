import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService(FirebaseStorage.instance);
});

class StorageService {
  final FirebaseStorage _storage;

  StorageService(this._storage);

  Future<String> uploadProfileImage(File file, String userId) async {
    try {
      final path =
          'Profile_Images/$userId/${DateTime.now().millisecondsSinceEpoch}';
      final ref = _storage.ref().child(path);

      // 메타데이터 추가
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'userId': userId},
      );

      await ref.putFile(file, metadata);
      final downloadUrl = await ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Storage error: $e'); // 디버깅을 위한 에러 로그
      throw Exception('이미지 업로드 실패: $e');
    }
  }

  Future<void> deleteProfileImage(String imageUrl) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      print('Delete storage error: $e');
      // 삭제 실패해도 계속 진행
    }
  }
}
