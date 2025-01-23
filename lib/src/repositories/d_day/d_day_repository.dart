import '../../datasource/local/d_day_local_datasource/d_day_local_datasource.dart';
import '../../datasource/remote/d_day/create_dday_api.dart';
import '../../datasource/remote/d_day/d_day_remote_datasource.dart';
import '../../datasource/remote/d_day/get_my_ddays_api.dart';
import '../../datasource/remote/d_day/update_dday_api.dart';
import '../../models/d_day/d_day.dart';

class DDayRepository {
  final DDayLocalDatasource _localDataSource;
  final DDayRemoteDatasource _remoteDatasource;

  DDayRepository(this._localDataSource, this._remoteDatasource);

  Future<void> addDDay(DDay dDay) async {
    final dDayId = await _remoteDatasource.addDDay(localToCreateDto(dDay));
    await _localDataSource.addDDay(dDay.copyWith(ddayId: dDayId));
  }

  Future<List<DDay>> getAllDDay(bool isConnected) async {
    final localDDayList = await _localDataSource.getAllDDay();

    if (isConnected) {
      final dDaysInfo = await _remoteDatasource.getMyDdays();
      if (dDaysInfo.isNotEmpty) {
        final dDayList =
            dDaysInfo.map((dDayInfo) => dDayInfoToDDay(dDayInfo)).toList();

        await _localDataSource.addAllDDay(dDayList);

        return dDayList;
      }
    }
    return localDDayList;
  }

  Future<void> updateDDay(DDay updateDDay) async {
    await _remoteDatasource.updateDday(localToUpdateDto(updateDDay));
    await _localDataSource.updateDDay(updateDDay);
  }

  Future<void> deleteDDay(String dDayId) async {
    await _remoteDatasource.deleteDday(dDayId);
    await _localDataSource.deleteDDay(dDayId);
  }

  Future<void> initializeDDay(bool isConnected) async {
    if (isConnected) {
      await _localDataSource.clearBox();
      final dDaysInfo = await _remoteDatasource.getMyDdays();
      if (dDaysInfo.isEmpty) {
        return;
      } else {
        final dDayList =
            dDaysInfo.map((dDayInfo) => dDayInfoToDDay(dDayInfo)).toList();
        await _localDataSource.addAllDDay(dDayList);
      }
    } else {
      return;
    }
  }

  CreateDdayApiReqDto localToCreateDto(DDay dDay) {
    return CreateDdayApiReqDto(
      title: dDay.title,
      color: dDay.color,
      targetDatetime: dDay.targetDatetime,
    );
  }

  UpdateDdayApiReqDto localToUpdateDto(DDay dDay) {
    return UpdateDdayApiReqDto(
      ddayId: dDay.ddayId ?? '',
      title: dDay.title,
      color: dDay.color,
      targetDatetime: dDay.targetDatetime,
    );
  }

  DDay dDayInfoToDDay(DdayInfo info) {
    return DDay(
      ddayId: info.ddayId,
      title: info.title,
      color: info.color,
      targetDatetime: info.targetDatetime,
    );
  }
}
