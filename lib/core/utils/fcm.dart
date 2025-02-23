import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
    if (!Platform.isIOS) return;

    int attempts = 0;
    const maxAttempts = 5;
    const delay = Duration(seconds: 3);

    while (attempts < maxAttempts) {
      try {
        final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        print('Attempt ${attempts + 1}: APNS Token = $apnsToken');

        if (apnsToken != null) {
          print('APNS Token successfully obtained: $apnsToken');
          return;
        }

        // iOS 권한 상태 확인
        final settings =
            await FirebaseMessaging.instance.getNotificationSettings();
        print('Current iOS permission status: ${settings.authorizationStatus}');
      } catch (e) {
        print('APNS Token error on attempt ${attempts + 1}: $e');
      }

      await Future.delayed(delay);
      attempts++;
    }

    // 토큰을 얻지 못해도 앱 실행은 계속되도록 함
    print('Warning: Failed to get APNS token after $maxAttempts attempts');
  }

  static Future<String?> _getDeviceToken() async {
    try {
      if (Platform.isAndroid) {
        return await FirebaseMessaging.instance.getToken();
      } else if (Platform.isIOS) {
        // iOS의 경우 APNS 토큰을 먼저 확인
        final apnsToken = await _getAPNSToken();
        if (apnsToken != null) {
          return await FirebaseMessaging.instance.getToken();
        }
      }
    } catch (e) {
      print('Error getting device token: $e');
    }
    return null;
  }

  static Future<String?> _getAPNSToken() async {
    // iOS 권한 요청
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      criticalAlert: true,
      announcement: true,
    );
    print('iOS permission status: ${settings.authorizationStatus}');

    // APNS 토큰 획득 시도
    int attempts = 0;
    const maxAttempts = 5;

    while (attempts < maxAttempts) {
      try {
        final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if (apnsToken != null) {
          print('APNS Token obtained: $apnsToken');
          return apnsToken;
        }
        print('Waiting for APNS token... (${attempts + 1}/$maxAttempts)');
        await Future.delayed(const Duration(seconds: 1));
      } catch (e) {
        print('Error getting APNS token: $e');
      }
      attempts++;
    }
    return null;
  }

  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final messaging = FirebaseMessaging.instance;

      // Android 채널 설정을 먼저 수행
      if (Platform.isAndroid) {
        await messaging.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

        final androidChannel = AndroidNotificationChannel(
          'high_importance_channel',
          'High Importance Notifications',
          description: '이 채널은 중요 알림에 사용됩니다.',
          importance: Importance.max,
        );

        final flutterLocalNotificationsPlugin =
            FlutterLocalNotificationsPlugin();
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(androidChannel);
      }

      await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // 명시적으로 채널 ID 설정
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // Android용 채널 ID 설정
      if (Platform.isAndroid) {
        await messaging.getNotificationSettings();
      }

      // 토큰 가져오기 시도
      String? token;
      int attempts = 0;
      const maxAttempts = 3;

      while (token == null && attempts < maxAttempts) {
        print('Attempting to get device token (${attempts + 1}/$maxAttempts)');
        token = await _getDeviceToken();

        if (token == null) {
          if (Platform.isIOS) {
            // iOS의 경우 더 오래 대기
            await Future.delayed(const Duration(seconds: 2));
          } else {
            await Future.delayed(const Duration(seconds: 1));
          }
        }
        attempts++;
      }

      if (token != null) {
        print('Device token successfully obtained: $token');
        await FirebaseMessaging.instance.subscribeToTopic('all');

        // 토큰 리프레시 리스너
        FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
          print('FCM token refreshed: $newToken');
        });
      } else {
        print('Failed to obtain device token');
      }

      // 메시지 핸들러 등록
      FirebaseMessaging.onMessage.listen((message) {
        print('Received foreground message: ${message.messageId}');
        _handleMessage(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        print('Opened app from background message: ${message.messageId}');
        _handleMessage(message);
      });

      final initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        print('Opened app from terminated state: ${initialMessage.messageId}');
        _handleMessage(initialMessage);
      }

      _isInitialized = true;
      print('FCM initialization completed successfully');
    } catch (e, stack) {
      print('FCM initialization error: $e');
      print('Stack trace: $stack');
      _isInitialized = false;
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
