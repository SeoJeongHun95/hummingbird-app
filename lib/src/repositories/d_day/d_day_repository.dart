import 'package:uuid/uuid.dart';

import '../../datasource/local/d_day_local_datasource/d_day_local_datasource.dart';
import '../../models/d_day/d_day.dart';

class DDayRepository {
  final DDayLocalDatasource _localDataSource;

  DDayRepository(this._localDataSource);

  Future<void> addDDay(DDay dDay) async {
    //TODO: Firestore 연결 전 임시 uuid
    final dDayId = Uuid().v4();

    await _localDataSource.addDDay(dDay.copyWith(ddayId: dDayId));
  }

  Future<List<DDay>> getAllDDay(bool isConnected) async {
    final localDDayList = await _localDataSource.getAllDDay();

    return localDDayList;
  }

  Future<void> updateDDay(DDay updateDDay) async {
    await _localDataSource.updateDDay(updateDDay);
  }

  Future<void> deleteDDay(String dDayId) async {
    await _localDataSource.deleteDDay(dDayId);
  }

  // Future<void> initializeDDay(bool isConnected) async {
  //   if (isConnected) {
  //     await _localDataSource.clearBox();
  //     final dDaysInfo = await _remoteDatasource.getMyDdays();
  //     if (dDaysInfo.isEmpty) {
  //       return;
  //     } else {
  //       final dDayList =
  //           dDaysInfo.map((dDayInfo) => dDayInfoToDDay(dDayInfo)).toList();
  //       await _localDataSource.addAllDDay(dDayList);
  //     }
  //   } else {
  //     return;
  //   }
  // }
}
