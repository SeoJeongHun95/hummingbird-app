import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/d_day/d_day.dart';
import '../../providers/d_day/fake_d_day_repository_provider.dart';
import '../../repositories/d_day/d_day_repository.dart';

part 'd_day_view_model.g.dart';

@riverpod
class DDayViewModel extends _$DDayViewModel {
  late final DDayRepository repository;

  @override
  Future<List<DDay>> build() async {
    repository = ref.watch(
        fakeDDayRepositoryProvider); //TODO: 서버 통신 구현 후 real repository 로 전환
    final dDays = await repository.getAllDDay();
    return getSortedDDays(dDays);
  }

  Future<void> addDDay(DDay dDay) async {
    state = await AsyncValue.guard(() async {
      await repository.addDDay(dDay);

      final previousState = await future;
      return getSortedDDays([...previousState, dDay]);
    });
  }

  Future<void> updateDDay(int index, DDay updateDDay) async {
    state = await AsyncValue.guard(() async {
      await repository.updateDDay(index, updateDDay);

      final previousState = await future;

      final newState = [...previousState];
      newState[index] = updateDDay;

      return getSortedDDays(newState);
    });
  }

  Future<void> deleteDDay(int index) async {
    state = await AsyncValue.guard(() async {
      await repository.deleteDDay(index);

      final previousState = await future;

      final newState = [...previousState];
      newState.removeAt(index);

      return newState;
    });
  }

  List<DDay> getSortedDDays(List<DDay> dDays) {
    dDays.sort((a, b) => a.goalDate.compareTo(b.goalDate));
    return dDays;
  }

  ({List<String> goalTitleList, List<String> dDayIndicatorList}) getDDayInfo(
      List<DDay> dDays) {
    List<String> goalTitleList = [];
    List<String> dDayIndicatorList = [];
    for (int i = 0; i < dDays.length; i++) {
      goalTitleList.add(dDays[i].goalTitle);
      dDayIndicatorList.add(getDDayIndicator(dDays[i].goalDate));
    }
    return (goalTitleList: goalTitleList, dDayIndicatorList: dDayIndicatorList);
  }

  // List<String> getDDayTitles(List<DDay> dDays) =>
  //     dDays.map((dDay) => dDay.goalTitle).toList();

  // List<String> getDDayIndicators(List<DDay> dDays) =>
  //     dDays.map((dDay) => getDDayIndicator(dDay.goalDate)).toList();

  String getDDayIndicator(int date) {
    final now = DateTime.now();
    final goalDateWithTime =
        DateTime.fromMillisecondsSinceEpoch(date).toLocal();

    // 시,분,초를 00:00:00 으로 설정하여 시간으로 인한 오차 방지
    final today = DateTime(now.year, now.month, now.day);
    final goalDate = DateTime(
        goalDateWithTime.year, goalDateWithTime.month, goalDateWithTime.day);

    final difference = today.difference(goalDate).inDays;

    if (difference == 0) {
      return 'D-day';
    }

    return difference < 0 ? 'D$difference' : 'D+$difference';
  }

  String getFormattedDate(int date) {
    final goalDate = DateTime.fromMillisecondsSinceEpoch(date).toLocal();
    final String dateFormat = 'yyyy-MM-dd, HH:mm';
    return DateFormat(dateFormat).format(goalDate);
  }
}
