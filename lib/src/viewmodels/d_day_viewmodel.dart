import 'package:hummingbird/src/providers/d_day_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/d_day/d_day.dart';
import '../repositories/d_day_repository.dart';

part 'd_day_viewmodel.g.dart';

@riverpod
class DDayViewmodel extends _$DDayViewmodel {
  late final DDayRepository repository;

  @override
  Future<List<DDay>> build() {
    repository = ref.watch(dDayRepositoryProvider);
    return repository.getAllDDay();
  }

  Future<void> addDDay(DDay dDay) async {
    repository.addDDay(dDay);
  }

  Future<void> updateDDay(int index, DDay updateDDay) async {
    repository.updateDDay(index, updateDDay);
  }

  Future<void> deleteDDay(int index) async {
    repository.deleteDDay(index);
  }
}
