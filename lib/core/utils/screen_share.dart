import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../main.dart';

class ScreenShare {
  final ScreenshotController screenshotController = ScreenshotController();

  Widget wrapWithScreenshot({required Widget child}) {
    return Screenshot(
      controller: screenshotController,
      child: child,
    );
  }

  Future<bool> _checkAndRequestPermission() async {
    if (Platform.isAndroid) {
      if (Platform.isAndroid &&
          await Permission.photos.request().isGranted &&
          await Permission.videos.request().isGranted) {
        return true;
      }
      return false;
    }
    return true; // iOS는 Info.plist로 처리
  }

  Future<void> captureAndShare(Widget widget) async {
    try {
      final hasPermission = await _checkAndRequestPermission();
      if (!hasPermission) {
        throw Exception('저장소 권한이 거부되었습니다');
      }

      // 캡처할 위젯을 렌더링
      final imageBytes = await screenshotController.captureFromWidget(
        widget,
        delay: const Duration(milliseconds: 100),
        context: navigatorKey.currentContext,
        targetSize: const Size(1080, 1920), // 적절한 크기 설정
      );

      final directory = await getTemporaryDirectory();
      final imagePath = File('${directory.path}/My_MBTI_Learning_Style.png');
      await imagePath.writeAsBytes(imageBytes);

      await Share.shareXFiles(
        [XFile(imagePath.path)],
        text: tr('mbtiResult.CheckMyMBTI'),
      );
    } catch (e) {
      debugPrint('Error sharing screenshot: $e');
      rethrow;
    }
  }
}
