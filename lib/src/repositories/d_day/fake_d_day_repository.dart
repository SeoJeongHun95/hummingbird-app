import '../../datasource/local/d_day_local_datasource/dummy_data.dart';
import '../../models/d_day/d_day.dart';
import 'd_day_repository.dart';

class FakeDDayRepository implements DDayRepository {
  @override
  Future<List<DDay>> getAllDDay() async {
    return DummyData.dummyDDayList;
  }

  @override
  Future<void> addDDay(DDay dDay) async {
    return;
  }

  @override
  Future<void> updateDDay(int index, DDay updateDDay) async {
    return;
  }

  @override
  Future<void> deleteDDay(int index) async {
    return;
  }
}
