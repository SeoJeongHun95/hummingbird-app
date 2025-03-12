import 'package:flutter/widgets.dart';

import 'suduck_timer_provider_2_0.dart';

class TimerLifecycleManager with WidgetsBindingObserver {
  final SuDuckTimer timerProvider;
  int? _pausedAt;

  TimerLifecycleManager(this.timerProvider) {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _pausedAt = DateTime.now().millisecondsSinceEpoch;
    } else if (state == AppLifecycleState.resumed &&
        timerProvider.state.isRunning) {
      if (_pausedAt != null) {
        int now = DateTime.now().millisecondsSinceEpoch;
        int diff = ((now - _pausedAt!) / 1000).toInt();
        timerProvider.updateElapsedTime(diff);
      }
      _pausedAt = null;
    }
  }
}
