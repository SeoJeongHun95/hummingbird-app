import 'package:hive/hive.dart';

import '../../../models/d_day/d_day.dart';

class DDayLocalDatasource {
  final Box<DDay> _box;

  DDayLocalDatasource(this._box);

  Future<void> addDDay(DDay dDay) async {
    await _box.add(dDay);
  }

  Future<List<DDay>> getAllDDay() async {
    return _box.values.toList();
  }

  Future<void> updateDDay(int index, DDay updateDDay) async {
    if (index >= 0 && index < _box.length) {
      await _box.putAt(index, updateDDay);
    } else {
      throw Exception('Invalid index $index');
    }
  }

  Future<void> deleteDDay(int index) async {
    await _box.deleteAt(index);
  }
}
