import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../datasource/suduck_timer_state.dart';
import '../../repositories/suduck_timer_repositories.dart';

part 'suduck_timer_provider.g.dart';

class TimerState {
  final int elapsedTime;
  final int breakTime;
  final bool isRunning;

  TimerState({
    required this.elapsedTime,
    required this.breakTime,
    required this.isRunning,
  });

  TimerState copyWith({int? elapsedTime, int? breakTime, bool? isRunning}) {
    return TimerState(
      elapsedTime: elapsedTime ?? this.elapsedTime,
      breakTime: breakTime ?? this.breakTime,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}

@Riverpod(keepAlive: true)
class SuDuckTimer extends _$SuDuckTimer {
  Timer? _elapsedtimer;
  Timer? _breaktimer;
  late final SuduckTimerState suduckLocalState;
  late final SuduckTimerRepositories suduckRepo;

  @override
  TimerState build() {
    final box = Hive.box<List<int>>('suduck');
    suduckLocalState = SuduckTimerState(box);
    suduckRepo = SuduckTimerRepositories(suduckLocalState);

    _restoreTimerState();

    return TimerState(elapsedTime: 0, breakTime: 0, isRunning: false);
  }

  void startTimer() async {
    if (state.isRunning) return;
    _breaktimer?.cancel();

    final startTime = DateTime.now().millisecondsSinceEpoch;
    await suduckRepo.addSuDuckTimerState([startTime, state.breakTime]);

    _startTimerLoop();
    state = state.copyWith(isRunning: true);
  }

  void stopTimer() async {
    _elapsedtimer?.cancel();
    _breaktimer?.cancel();

    _startBreakLoop();
    state = state.copyWith(isRunning: false);
  }

  void resetTimer() async {
    _elapsedtimer?.cancel();
    _breaktimer?.cancel();

    await suduckRepo.deleteSuDuckTimerState();

    state = TimerState(elapsedTime: 0, breakTime: 0, isRunning: false);
  }

  Future<void> _restoreTimerState() async {
    final storedTime = await suduckLocalState.getSuDuckTimerStates();

    if (storedTime != null) {
      final elapsedTime =
          ((DateTime.now().millisecondsSinceEpoch - storedTime[0]) / 1000)
                  .toInt() -
              storedTime[1];

      state = state.copyWith(
        elapsedTime: elapsedTime,
        breakTime: storedTime[1],
        isRunning: true,
      );

      if (state.isRunning) {
        _startTimerLoop();
      }
    }
  }

  void _startTimerLoop() {
    _elapsedtimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(elapsedTime: state.elapsedTime + 1);
    });
  }

  void _startBreakLoop() {
    _breaktimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      state = state.copyWith(breakTime: state.breakTime + 1);

      if (state.breakTime % 10 == 0) {
        await suduckLocalState.updateSuDuckTimerState(state.breakTime);
      }
    });
  }
}
