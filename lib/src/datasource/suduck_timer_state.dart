import 'package:hive_flutter/hive_flutter.dart';

class SuduckTimerState {
  final Box<List<int>> _box;

  SuduckTimerState(this._box);

  Future<void> addSuDuckTimerState(List<int> timerState) async {
    _box.isEmpty ? _box.add(timerState) : null;
  }

  Future<List<int>?> getSuDuckTimerStates() async {
    return _box.isNotEmpty ? _box.getAt(0) : null;
  }

  Future<void> deleteSuDuckTimerState() async {
    await _box.clear();
  }

  Future<void> updateSuDuckTimerState(int breakTime) async {
    final temp = _box.isNotEmpty ? _box.getAt(0) : null;
    if (temp != null) {
      _box.putAt(0, [temp[0], breakTime]);
    }
  }
}
