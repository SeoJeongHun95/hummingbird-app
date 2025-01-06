import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../datasource/local/d_day_local_datasource.dart';
import '../models/d_day/d_day.dart';
import '../repositories/d_day_repository.dart';

part 'd_day_repository_provider.g.dart';

@riverpod
DDayRepository dDayRepository(Ref ref) {
  final box = Hive.box<DDay>('dDayBox');
  final dDayLocalDataSource = DDayLocalDatasource(box);
  return DDayRepository(dDayLocalDataSource);
}
