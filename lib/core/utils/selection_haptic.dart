import 'package:haptic_feedback/haptic_feedback.dart';

class SelectionHaptic {
  static Future<void> vibrate() async {
    final canVibrate = await Haptics.canVibrate();
    if (canVibrate) {
      await Haptics.vibrate(HapticsType.selection);
    }
  }

  // 경고용 햅틱 피드백 메서드 추가
  static Future<void> warning() async {
    final canVibrate = await Haptics.canVibrate();
    if (canVibrate) {
      // 경고 효과를 위한 3번의 연속 진동
      await Haptics.vibrate(HapticsType.warning);
      await Future.delayed(const Duration(milliseconds: 100));
      await Haptics.vibrate(HapticsType.warning);
      await Future.delayed(const Duration(milliseconds: 100));
      await Haptics.vibrate(HapticsType.warning);
    }
  }
}
