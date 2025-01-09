import '../datasource/local/d_day_local_datasource/d_day_local_datasource.dart';
import '../models/d_day/d_day.dart';

class DDayRepository {
  final DDayLocalDatasource _dataSource;

  DDayRepository(this._dataSource);

  Future<void> addDDay(DDay dDay) async {
    _dataSource.addDDay(dDay);
  }

  Future<List<DDay>> getAllDDay() async {
    return _dataSource.getAllDDay();
  }

  Future<void> updateDDay(int index, DDay updateDDay) async {
    _dataSource.updateDDay(index, updateDDay);
  }

  Future<void> deleteDDay(int index) async {
    _dataSource.deleteDDay(index);
  }

  String getDDayString(int date) {
    final now = DateTime.now();
    final currentDate =
        DateTime(now.year, now.month, now.day); // 시간을 00:00:00 로 설정

    final goalDateWithTime = DateTime.fromMillisecondsSinceEpoch(date);
    final goalDate = DateTime(goalDateWithTime.year, goalDateWithTime.month,
        goalDateWithTime.day); // 시간을 00:00:00 로 설정

    return goalDate.difference(currentDate).inDays.toString();
  }
}
