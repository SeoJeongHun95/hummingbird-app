import '../datasource/suduck_timer_state.dart';

class SuduckTimerRepositories {
  SuduckTimerRepositories(this.suduckTimerState);

  final SuduckTimerState suduckTimerState;

  Future<void> addSuDuckTimerState(List timerState) async {
    return suduckTimerState.addSuDuckTimerState(timerState);
  }

  Future<List?> getSuDuckTimerStates() async {
    return suduckTimerState.getSuDuckTimerStates();
  }

  Future<void> deleteSuDuckTimerState() async {
    return suduckTimerState.deleteSuDuckTimerState();
  }

  Future<void> updateSuDuckTimerState(int breakTime) async {
    return suduckTimerState.updateSuDuckTimerState(breakTime);
  }
}
