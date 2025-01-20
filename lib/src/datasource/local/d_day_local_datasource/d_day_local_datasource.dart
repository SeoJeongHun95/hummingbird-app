import 'package:hive/hive.dart';

import '../../../models/d_day/d_day.dart';

class DDayLocalDatasource {
  final Box<DDay> _box;

  DDayLocalDatasource(this._box);

  Future<void> addDDay(DDay dDay) async {
    await _box.put(dDay.ddayId, dDay);
  }

  Future<List<DDay>> getAllDDay() async {
    return _box.values.toList();
  }

  Future<void> updateDDay(DDay updatedDDay) async {
    await _box.put(updatedDDay.ddayId, updatedDDay);
  }

  Future<void> deleteDDay(String dDayId) async {
    await _box.delete(dDayId);
  }

  Future<void> addAllDDay(List<DDay> dDayList) async {
    for (int i = 0; i < dDayList.length; i++) {
      addDDay(dDayList[i]);
    }
  }

  Future<void> clearBox() async {
    _box.clear();
  }
}
