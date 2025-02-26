import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'high_importance_channel';
  static const String _channelName = 'High Importance Notifications';

  Future<void> initialize() async {
    const androidChannel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: '이 채널은 중요 알림에 사용됩니다.',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    final plugin = _notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await plugin?.createNotificationChannel(androidChannel);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        print('Local Notification clicked: ${details.payload}');
      },
    );

    print('NotificationService initialized successfully');
  }

  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      final AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: '이 채널은 중요 알림에 사용됩니다.',
        importance: Importance.max,
        priority: Priority.max,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        icon: '@mipmap/launcher_icon',
        fullScreenIntent: true,
        category: AndroidNotificationCategory.message,
      );

      final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await _notificationsPlugin.show(
        id,
        title,
        body,
        platformChannelSpecifics,
        payload: payload,
      );

      print('Local notification shown: ID($id) Title($title) Body($body)');
    } catch (e) {
      print('Error showing notification: $e');
    }
  }
}
