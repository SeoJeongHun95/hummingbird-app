import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../datasource/suduck_timer_state.dart';
import '../../models/study_record/study_record.dart';
import '../../models/subject/subject.dart';
import '../../repositories/suduck_timer_repositories.dart';
import '../../viewmodels/study_record/study_record_viewmodel.dart';
import '../../viewmodels/timer/timer_bg_color_provider.dart';

part 'suduck_timer_provider.g.dart';

final Subject noSubject = Subject(title: "미분류", color: "ba4849", order: -1);

class TimerState {
  final int elapsedTime;
  final int breakTime;
  final bool isRunning;
  final Subject? currSubject;

  TimerState({
    required this.elapsedTime,
    required this.breakTime,
    required this.isRunning,
    this.currSubject,
  });

  TimerState copyWith({
    int? elapsedTime,
    int? breakTime,
    bool? isRunning,
    Subject? currSubject,
  }) {
    return TimerState(
      elapsedTime: elapsedTime ?? this.elapsedTime,
      breakTime: breakTime ?? this.breakTime,
      isRunning: isRunning ?? this.isRunning,
      currSubject: currSubject ?? this.currSubject,
    );
  }
}

@Riverpod(keepAlive: true)
class SuDuckTimer extends _$SuDuckTimer {
  Timer? _elapsedTimer;
  Timer? _breakTimer;
  late final SuduckTimerState suduckLocalState;
  late final SuduckTimerRepositories suduckRepo;

  @override
  TimerState build() {
    final box = Hive.box<List<int>>('suduck');
    suduckLocalState = SuduckTimerState(box);
    suduckRepo = SuduckTimerRepositories(suduckLocalState);

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

    final startTime = DateTime.now().millisecondsSinceEpoch;
    await suduckRepo.addSuDuckTimerState([startTime, state.breakTime]);

    final newRecord = StudyRecord(
      title: subject?.title ?? noSubject.title,
      color: subject?.color ?? noSubject.color,
      order: subject?.order ?? noSubject.order,
      startAt: startTime,
    );

    await ref
        .read(studyRecordViewModelProvider.notifier)
        .addStudyRecord(newRecord);

    _updateBgColor(subject?.color);
    _startTimerLoop();

    state = state.copyWith(isRunning: true, currSubject: subject);
  }

  void stopTimer() {
    _cancelElapsedTimer();
    _startBreakLoop();
    state = state.copyWith(isRunning: false);
  }

  Future<void> resetTimer() async {
    _cancelAllTimers();
    if (state.currSubject != null) {
      await ref.read(studyRecordViewModelProvider.notifier).deleteStudyRecord();
    }
    await suduckRepo.deleteSuDuckTimerState();

    _updateBgColor(null);

    state = TimerState(
      elapsedTime: 0,
      breakTime: 0,
      isRunning: false,
      currSubject: null,
    );
  }

  Future<void> saveTimer() async {
    _cancelAllTimers();

    final endTime = DateTime.now().millisecondsSinceEpoch;

    final currentSubject = state.currSubject ?? noSubject;
    final updatedRecord = StudyRecord(
      title: currentSubject.title,
      color: currentSubject.color,
      order: currentSubject.order,
      endAt: endTime,
      elapsedTime: state.elapsedTime,
      breakTime: state.breakTime,
    );
    await ref
        .read(studyRecordViewModelProvider.notifier)
        .updateStudyRecord(updatedRecord);

    await suduckRepo.deleteSuDuckTimerState();

    _updateBgColor(null);

    state = TimerState(
      elapsedTime: 0,
      breakTime: 0,
      isRunning: false,
      currSubject: null,
    );
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
    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(elapsedTime: state.elapsedTime + 1);
    });
  }

  void _startBreakLoop() {
    _breakTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      state = state.copyWith(breakTime: state.breakTime + 1);
      if (state.breakTime % 10 == 0) {
        await suduckLocalState.updateSuDuckTimerState(state.breakTime);
      }
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
