import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  factory AnalyticsService() {
    return _instance;
  }

  AnalyticsService._internal();

  // 페이지 이동 이벤트
  Future<void> logPageNavigation(String fromPage, String toPage) async {
    await analytics.logEvent(
      name: 'page_navigation',
      parameters: {
        'from_page': fromPage,
        'to_page': toPage,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // 화면 조회 이벤트
  Future<void> logScreenView(String screenName, String screenClass) async {
    await analytics.logEvent(
      name: 'screen_view',
      parameters: {
        'screen_name': screenName,
        'screen_class': screenClass,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // 타이머 시작 이벤트
  Future<void> logTimerStart(String timerType) async {
    await analytics.logEvent(
      name: 'timer_start',
      parameters: {
        'timer_type': timerType,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // 타이머 저장 이벤트
  Future<void> logTimerSave(String timerType, Duration duration) async {
    await analytics.logEvent(
      name: 'timer_save',
      parameters: {
        'timer_type': timerType,
        'duration': duration.inSeconds,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // 로그인 이벤트
  Future<void> logLogin(String loginMethod) async {
    await analytics.logEvent(
      name: 'login',
      parameters: {
        'login_method': loginMethod,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // 회원가입 이벤트
  Future<void> logSignUp(String signUpMethod) async {
    await analytics.logEvent(
      name: 'sign_up',
      parameters: {
        'sign_up_method': signUpMethod,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }
}
