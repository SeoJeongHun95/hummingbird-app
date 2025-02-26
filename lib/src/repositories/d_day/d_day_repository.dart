import '../../datasource/remote/d_day/d_day_remote_datasource.dart';
import '../../models/d_day/d_day.dart';

class DDayRepository {
  final DDayRemoteDatasource _remoteDatasource;

  DDayRepository(this._remoteDatasource);

  Future<void> addDDay(DDay dDay) async {
    await _remoteDatasource.addDDay(dDay);
  }

  Future<List<DDay>> getAllDDay() async {
    final localDDayList = await _remoteDatasource.getAllDDay();

    return localDDayList;
  }

  Future<void> updateDDay(DDay updateDDay) async {
    await _remoteDatasource.updateDDay(updateDDay);
  }

  Future<void> deleteDDay(String dDayId) async {
    await _remoteDatasource.deleteDDay(dDayId);
  }
}
