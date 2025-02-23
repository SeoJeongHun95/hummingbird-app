import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

import '../services/notification_service.dart';

class FcmManager {
  static final NotificationService _notificationService =
      NotificationService.instance;
  static bool _isInitialized = false;

  static Future<void> requestPermission() async {
    if (Platform.isIOS) {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      // iOS에서 APNS 토큰을 얻을 때까지 대기
      await _waitForAPNSToken();
    }
  }

  static Future<void> _waitForAPNSToken() async {
    int attempts = 0;
    const maxAttempts = 5;

    while (attempts < maxAttempts) {
      final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      if (apnsToken != null) {
        print('APNS Token obtained: $apnsToken');
        return;
      }
      await Future.delayed(const Duration(seconds: 1));
      attempts++;
    }
    print('Failed to get APNS token after $maxAttempts attempts');
  }

  static Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;

    await requestPermission();

    //FCM 토큰 가지고 오고 서버로 보내기
    final token = await FirebaseMessaging.instance.getToken();
    print('FCM token: $token');

    // 토픽 구독 추가
    await FirebaseMessaging.instance.subscribeToTopic('all');

    //iOS foreground notification 설정
    if (Platform.isIOS) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    // Foreground handler 등록
    FirebaseMessaging.onMessage.listen((message) async {
      print('Handling foreground message');
      await _handleMessage(message);
    });

    // Background/Terminated handler 등록
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      print('Handling background/terminated message');
      await _handleMessage(message);
    });

    // 앱이 종료된 상태에서 푸시 알림을 클릭하여 앱을 실행했을 때
    final firstMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (firstMessage != null) {
      _handleMessage(firstMessage);
    }
  }

  static Future<void> _handleMessage(RemoteMessage message) async {
    try {
      if (!_shouldShowNotification(message)) {
        print('Skipping notification: Invalid message content');
        return;
      }

      await _notificationService.showNotification(
        title: _getNotificationTitle(message),
        body: _getNotificationBody(message),
        payload: message.messageId,
      );
    } catch (e) {
      print('Error handling message: $e');
    }
  }

  static bool _shouldShowNotification(RemoteMessage message) {
    return message.notification != null || message.data.isNotEmpty;
  }

  static String _getNotificationTitle(RemoteMessage message) {
    return message.notification?.title ??
        message.data['title'] ??
        'New Message';
  }

  static String _getNotificationBody(RemoteMessage message) {
    return message.notification?.body ??
        message.data['body'] ??
        'You have a new message';
  }
}
