import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/d_day/d_day.dart';
import '../../providers/d_day/d_day_repository_provider.dart';
import '../../providers/network_status/network_state_provider.dart';
import '../../repositories/d_day/d_day_repository.dart';

part 'd_day_view_model.g.dart';

@Riverpod(keepAlive: true)
class DDayViewModel extends _$DDayViewModel {
  late DDayRepository repository;

  @override
  Future<List<DDay>> build() async {
    repository = ref.watch(dDayRepositoryProvider);
    final isConnected = await ref.watch(networkStateProvider.future);
    final dDays = await repository.getAllDDay(isConnected);
    return getSortedDDays(dDays);
  }

  Future<void> addDDay(DDay dDay) async {
    final bool isConnected = await ref.read(networkStateProvider.future);
    state = await AsyncValue.guard(() async {
      await repository.addDDay(dDay);
      final newList = await repository.getAllDDay(isConnected);

      return getSortedDDays(newList);
    });
  }

  Future<void> updateDDay(int index, DDay updateDDay) async {
    state = await AsyncValue.guard(() async {
      await repository.updateDDay(updateDDay);

      final previousState = await future;

      final newState = [...previousState];
      newState[index] = updateDDay;

      return getSortedDDays(newState);
    });
  }

  Future<void> deleteDDay(int index, String dDayId) async {
    state = await AsyncValue.guard(() async {
      await repository.deleteDDay(dDayId);

      final previousState = await future;

      final newState = [...previousState];
      newState.removeAt(index);

      return newState;
    });
  }

  Future<void> initializeDDay() async {
    bool isConnected;
    try {
      isConnected = await ref.read(networkStateProvider.future);
    } catch (e) {
      isConnected = false;
    }
    await repository.initializeDDay(isConnected);
  }

  List<DDay> getSortedDDays(List<DDay> dDays) {
    dDays.sort((a, b) => a.targetDatetime.compareTo(b.targetDatetime));
    return dDays;
  }

  ({List<String> goalTitleList, List<String> dDayIndicatorList}) getDDayInfo(
      List<DDay> dDays) {
    List<String> goalTitleList = [];
    List<String> dDayIndicatorList = [];
    for (int i = 0; i < dDays.length; i++) {
      goalTitleList.add(dDays[i].title);
      dDayIndicatorList.add(getDDayIndicator(dDays[i].targetDatetime));
    }
    return (goalTitleList: goalTitleList, dDayIndicatorList: dDayIndicatorList);
  }

  String getDDayIndicator(int dateByseconds) {
    final now = DateTime.now();
    final goalDateWithTime =
        DateTime.fromMillisecondsSinceEpoch(dateByseconds * 1000).toLocal();

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

  String getFormattedDate(int dateBySeconds) {
    final goalDate =
        DateTime.fromMillisecondsSinceEpoch(dateBySeconds * 1000).toLocal();
    final String dateFormat = 'yyyy-MM-dd, HH:mm';
    return DateFormat(dateFormat).format(goalDate);
  }
}
