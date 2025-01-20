import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/const/box_keys.dart';
import '../../datasource/local/d_day_local_datasource/d_day_local_datasource.dart';
import '../../datasource/remote/d_day/create_dday_api.dart';
import '../../datasource/remote/d_day/d_day_remote_datasource.dart';
import '../../datasource/remote/d_day/delete_dday_api.dart';
import '../../datasource/remote/d_day/get_my_ddays_api.dart';
import '../../datasource/remote/d_day/update_dday_api.dart';
import '../../models/d_day/d_day.dart';
import '../../repositories/d_day/d_day_repository.dart';

part 'd_day_repository_provider.g.dart';

@riverpod
DDayRepository dDayRepository(Ref ref) {
  final box = Hive.box<DDay>(BoxKeys.dDayBoxKey);
  final dDayLocalDataSource = DDayLocalDatasource(box);
  final createDdayApi = ref.watch(createDdayApiProvider);
  final getMyDdaysApi = ref.watch(getMyDdaysApiProvider);
  final updateDdayApi = ref.watch(updateDdayApiProvider);
  final deleteDdayApi = ref.watch(deleteDdayApiProvider);
  final dDayRemoteDataSource = DDayRemoteDatasource(
      createDdayApi: createDdayApi,
      getMyDdaysApi: getMyDdaysApi,
      updateDdayApi: updateDdayApi,
      deleteDdayApi: deleteDdayApi);

  return DDayRepository(dDayLocalDataSource, dDayRemoteDataSource);
}
