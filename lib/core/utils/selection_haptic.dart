import 'package:haptic_feedback/haptic_feedback.dart';

class SelectionHaptic {
  static Future<void> vibrate() async {
    final canVibrate = await Haptics.canVibrate();
    if (canVibrate) {
      await Haptics.vibrate(HapticsType.selection);
    }
  }
}
