import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  static FirebaseAnalytics get analytics => FirebaseAnalytics.instance;

  factory AnalyticsService() {
    return _instance;
  }

  AnalyticsService._internal();

  // 로그인 이벤트
  Future<void> logLogin(String method) async {
    await analytics.logLogin(loginMethod: method);
  }

  // 회원가입 이벤트
  Future<void> logSignUp(String method) async {
    await analytics.logSignUp(signUpMethod: method);
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
  Future<void> logTimerSave(String timerType, int duration) async {
    await analytics.logEvent(
      name: 'timer_save',
      parameters: {
        'timer_type': timerType,
        'duration': duration,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // 화면 전환 이벤트
  Future<void> logScreenView(String screenName) async {
    await analytics.logScreenView(
      screenName: screenName,
      screenClass: screenName,
    );
  }

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
}
