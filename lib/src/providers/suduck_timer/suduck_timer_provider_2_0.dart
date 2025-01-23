import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/get_epoch_time.dart';
import '../../models/study_record/study_record.dart';
import '../../models/subject/subject.dart';
import '../../viewmodels/study_record/study_record_viewmodel.dart';
import '../../viewmodels/timer/timer_bg_color_provider.dart';

part 'suduck_timer_provider_2_0.g.dart';

final Subject noSubject = Subject(title: "미분류", color: "ba4849", order: -1);

class TimerState {
  final bool isRunning;
  final Subject? currSubject;
  final int elapsedTime;
  final int breakTime;
  final int? startAt;
  final int? endAt;

  TimerState({
    required this.isRunning,
    this.currSubject,
    required this.elapsedTime,
    required this.breakTime,
    this.startAt,
    this.endAt,
  });

  TimerState copyWith({
    bool? isRunning,
    Subject? currSubject,
    int? elapsedTime,
    int? breakTime,
    int? startAt,
    int? endAt,
  }) {
    return TimerState(
      isRunning: isRunning ?? this.isRunning,
      currSubject: currSubject ?? this.currSubject,
      elapsedTime: elapsedTime ?? this.elapsedTime,
      breakTime: breakTime ?? this.breakTime,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
    );
  }
}

@Riverpod(keepAlive: true)
class SuDuckTimer extends _$SuDuckTimer {
  Timer? _elapsedTimer;
  Timer? _breakTimer;

  @override
  TimerState build() {
    return TimerState(
      elapsedTime: 0,
      breakTime: 0,
      isRunning: false,
      currSubject: null,
    );
  }

  Future<void> startTimer({Subject? subject}) async {
    if (state.isRunning) return;
    _cancelBreakTimer();

    _updateBgColor(subject?.color);
    _startTimerLoop();

    state = state.copyWith(
      isRunning: true,
      currSubject: subject,
      startAt: formattedEpochTime,
    );
  }

  void stopTimer() {
    _cancelAllTimers();
    _startBreakLoop();
    state = state.copyWith(isRunning: false);
  }

  Future<void> resetTimer() async {
    _cancelAllTimers();

    _updateBgColor(null);

    state = TimerState(
      isRunning: false,
      currSubject: null,
      elapsedTime: 0,
      breakTime: 0,
      startAt: null,
      endAt: null,
    );
  }

  Future<void> saveTimer() async {
    _cancelAllTimers();

    final currentSubject = state.currSubject ?? noSubject;

    final updatedRecord = StudyRecord(
      title: currentSubject.title,
      color: currentSubject.color,
      order: currentSubject.order,
      elapsedTime: state.elapsedTime,
      breakTime: state.breakTime,
      startAt: state.startAt,
      endAt: formattedEpochTime,
    );

    await ref
        .read(studyRecordViewModelProvider.notifier)
        .addStudyRecord(updatedRecord);

    resetTimer();
  }

  void setSubject(Subject subject) {
    if (!state.isRunning) {
      _updateBgColor(subject.color);
      state = state.copyWith(currSubject: subject);
    }
  }

  void resetSubject() {
    _updateBgColor(null);

    state = TimerState(
      elapsedTime: 0,
      breakTime: 0,
      isRunning: false,
      currSubject: null,
    );
  }

  void _startTimerLoop() {
    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(elapsedTime: state.elapsedTime + 1);
    });
  }

  void _startBreakLoop() {
    _breakTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      state = state.copyWith(breakTime: state.breakTime + 1);
    });
  }

  void _updateBgColor(String? color) {
    ref.read(timerBgColorProvider.notifier).changeColor(color: color);
  }

  void _cancelElapsedTimer() {
    _elapsedTimer?.cancel();
  }

  void _cancelBreakTimer() {
    _breakTimer?.cancel();
  }

  void _cancelAllTimers() {
    _cancelElapsedTimer();
    _cancelBreakTimer();
  }
}
