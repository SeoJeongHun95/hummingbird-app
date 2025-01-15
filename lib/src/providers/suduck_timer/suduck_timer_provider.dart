import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../datasource/suduck_timer_state.dart';
import '../../models/study_record/study_record.dart';
import '../../models/subject/subject.dart';
import '../../repositories/suduck_timer_repositories.dart';
import '../../viewmodels/study_record/study_record_viewmodel.dart';

part 'suduck_timer_provider.g.dart';

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
  Timer? _elapsedtimer;
  Timer? _breaktimer;
  late final SuduckTimerState suduckLocalState;
  late final SuduckTimerRepositories suduckRepo;

  @override
  TimerState build() {
    final box = Hive.box<List<int>>('suduck');
    suduckLocalState = SuduckTimerState(box);
    suduckRepo = SuduckTimerRepositories(suduckLocalState);

    // _restoreTimerState();

    return TimerState(
      elapsedTime: 0,
      breakTime: 0,
      isRunning: false,
      currSubject: null,
    );
  }

  void startTimer() async {
    if (state.isRunning) return;
    _breaktimer?.cancel();

    final startTime = DateTime.now().millisecondsSinceEpoch;
    await suduckRepo.addSuDuckTimerState([startTime, state.breakTime]);

    _startTimerLoop();
    state = state.copyWith(isRunning: true);
  }

  Future<void> startTimerWithSubject({required Subject subject}) async {
    if (state.isRunning) return;

    final startTime = DateTime.now().millisecondsSinceEpoch;
    await suduckRepo.addSuDuckTimerState([startTime, state.breakTime]);

    final todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final newRecord = StudyRecord(
      subject: subject,
      startAt: startTime,
    );

    await ref
        .read(studyRecordViewModelProvider.notifier)
        .addStudyRecord(todayDate, newRecord);

    _startTimerLoop();

    state = state.copyWith(isRunning: true, currSubject: subject);
  }

  void stopTimer() async {
    _elapsedtimer?.cancel();
    _breaktimer?.cancel();

    _startBreakLoop();
    state = state.copyWith(isRunning: false);
  }

  Future<void> resetTimer() async {
    _elapsedtimer?.cancel();
    _breaktimer?.cancel();

    final todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final currentState = state;

    if (currentState.currSubject != null) {
      await ref
          .read(studyRecordViewModelProvider.notifier)
          .deleteStudyRecord(todayDate);
    }

    await suduckRepo.deleteSuDuckTimerState();

    state = TimerState(
      elapsedTime: 0,
      breakTime: 0,
      isRunning: false,
      currSubject: null,
    );
  }

  Future<void> saveTimer() async {
    _elapsedtimer?.cancel();
    _breaktimer?.cancel();

    final todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final currentState = state;
    final endTime = DateTime.now().millisecondsSinceEpoch;

    //TODO 과목이 없다면 체크해서 과목 선택 로직 추가
    if (currentState.currSubject != null) {
      final updatedRecord = StudyRecord(
        subject: currentState.currSubject!,
        endAt: endTime,
        elapsedTime: currentState.elapsedTime,
        breakTime: currentState.breakTime,
      );

      await ref
          .read(studyRecordViewModelProvider.notifier)
          .updateStudyRecord(todayDate, updatedRecord);
    }

    await suduckRepo.deleteSuDuckTimerState();

    state = TimerState(
      elapsedTime: 0,
      breakTime: 0,
      isRunning: false,
      currSubject: null,
    );
  }

  void setSubject(Subject subject) {
    if (!state.isRunning) {
      state = state.copyWith(currSubject: subject);
    }
  }

  //TODO 타이머 복구 선택지 기능 어떻게할지
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
