import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'suduck_timer_provider.g.dart';

class TimerState {
  final int elapsedTime;
  final bool isRunning;

  TimerState({required this.elapsedTime, required this.isRunning});

  TimerState copyWith({int? elapsedTime, bool? isRunning}) {
    return TimerState(
      elapsedTime: elapsedTime ?? this.elapsedTime,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}

@Riverpod(keepAlive: true)
class SuDuckTimer extends _$SuDuckTimer {
  Timer? _timer;

  @override
  TimerState build() {
    return TimerState(elapsedTime: 0, isRunning: false);
  }

  void startTimer() {
    if (_timer != null || state.isRunning) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(elapsedTime: state.elapsedTime + 1);
    });
    state = state.copyWith(isRunning: true);
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    state = state.copyWith(isRunning: false);
  }

  void resetTimer() {
    _timer?.cancel();
    _timer = null;
    state = TimerState(elapsedTime: 0, isRunning: false);
  }

  void disposeTimer() {
    _timer?.cancel();
    _timer = null;
  }
}


//start를 누르면 hive를 통해 현제 시간과 눌렀음을 저장
//stop을 누르면 hive에 저장되어있는것을 삭제

//start를 누른채로 어플리케이션을 종료하고 어플리케이션이 다시시작되면 hive에 timer를 저장된 처음 누른 시간을 가져옴 
// 지금 시간 - 처음 누른 시간을 계산해서 elapsedTime을 계산한뒤 copywith 으로 넘김 