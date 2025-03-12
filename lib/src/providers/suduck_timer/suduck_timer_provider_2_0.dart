import 'dart:async';

import 'package:StudyDuck/src/providers/suduck_timer/timer_lifecycle_manager.dart';
import 'package:StudyDuck/src/repositories/subject/subject_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/selection_haptic.dart';
import '../../../core/utils/utils.dart';
import '../../datasource/suduck_timer_state.dart';
import '../../models/study_record/study_record.dart';
import '../../models/subject/subject.dart';
import '../../repositories/suduck_timer_repositories.dart';
import '../../viewmodels/study_record/study_record_viewmodel.dart';
import '../../viewmodels/timer/timer_bg_color_provider.dart';

part 'suduck_timer_provider_2_0.g.dart';

final Subject noSubject =
    Subject(subjectId: "0", title: "미분류", color: "ba4849", order: -1);

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
  late final SuduckTimerState suduckLocalState;
  late final SuduckTimerRepositories suduckRepo;
  late final TimerLifecycleManager _appLifecycleListener;

  @override
  TimerState build() {
    final box = Hive.box<List>('suduck');
    suduckLocalState = SuduckTimerState(box);
    suduckRepo = SuduckTimerRepositories(suduckLocalState);

    _appLifecycleListener = TimerLifecycleManager(this);

    _restoreTimerState();

    return TimerState(
      elapsedTime: 0,
      breakTime: 0,
      isRunning: false,
      currSubject: null,
    );
  }

  @override
  void dispose() {
    _appLifecycleListener.dispose();
    _cancelAllTimers();
    dispose();
  }

  void updateElapsedTime(int seconds) {
    state = state.copyWith(elapsedTime: state.elapsedTime + seconds);
  }

  Future<void> startTimer({Subject? subject}) async {
    await SelectionHaptic.vibrate();
    if (state.isRunning) return;
    _cancelBreakTimer();

    _updateBgColor(subject?.color);
    _startTimerLoop();

    final startTime = DateTime.now().millisecondsSinceEpoch;
    await suduckRepo.addSuDuckTimerState([
      startTime,
      state.breakTime,
      subject == null ? state.currSubject : subject.subjectId,
    ]);

    state = state.copyWith(
      isRunning: true,
      currSubject: subject,
      startAt: formattedEpochTime,
    );
  }

  void stopTimer() async {
    await SelectionHaptic.vibrate();
    _cancelAllTimers();
    _startBreakLoop();
    state = state.copyWith(isRunning: false);
  }

  Future<void> resetTimer() async {
    await SelectionHaptic.vibrate();
    _cancelAllTimers();

    _updateBgColor(null);

    await suduckRepo.deleteSuDuckTimerState();

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
    await SelectionHaptic.vibrate();
    _cancelAllTimers();

    final currentSubject = state.currSubject ?? noSubject;

    final updatedRecord = StudyRecord(
      subjectId: currentSubject.subjectId!,
      title: currentSubject.title,
      color: currentSubject.color,
      dateKey: formattedToday,
      elapsedTime: state.elapsedTime,
      breakTime: state.breakTime,
      startAt: state.startAt,
      endAt: formattedEpochTime,
    );

    await ref
        .read(studyRecordViewModelProvider.notifier)
        .addStudyRecord(updatedRecord);

    await suduckRepo.deleteSuDuckTimerState();

    resetTimer();
  }

  Future<void> _restoreTimerState() async {
    final restored = await suduckLocalState.getSuDuckTimerStates();
    var restoreFlag = false;

    if (restored != null) {
      restoreFlag = await showConfirmDialog("", "기존의 타이머가 있습니다. 복구하시겠습니까?");
    }

    if (!restoreFlag || restored == null) return;

    final now = DateTime.now().millisecondsSinceEpoch;

    final subjectFuture = findSubjectById(restored[2]);
    final elapsedTime = (((now - restored[0]) / 1000)) - restored[1];

    final restoredSubject = await subjectFuture;

    _updateBgColor(restoredSubject.color);

    state = state.copyWith(
      elapsedTime: elapsedTime.toInt(),
      breakTime: restored[1],
      isRunning: true,
      currSubject: restoredSubject,
    );

    _startTimerLoop();
  }

  Future<Subject> findSubjectById(String subId) async {
    List<Subject> subjects =
        await ref.read(subjectRepositoryProvider).getAllSubjects();

    return subjects.firstWhere(
      (sub) => sub.subjectId == subId,
      orElse: () => noSubject,
    );
  }

  void setSubject(Subject subject) {
    if (!state.isRunning && state.startAt == null) {
      _updateBgColor(subject.color);
      state = state.copyWith(currSubject: subject);
    }
  }

  void resetSubject() {
    if (!state.isRunning && state.startAt == null) {
      _updateBgColor(null);

      state = TimerState(
        elapsedTime: 0,
        breakTime: 0,
        isRunning: false,
        currSubject: null,
      );
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
