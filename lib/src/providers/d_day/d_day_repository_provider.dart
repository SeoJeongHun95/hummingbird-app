import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../datasource/remote/d_day/d_day_remote_datasource.dart';
import '../../repositories/d_day/d_day_repository.dart';

part 'd_day_repository_provider.g.dart';

@riverpod
DDayRepository dDayRepository(Ref ref) {
  final dDayRemoteDatasource = DDayRemoteDatasource();

  return DDayRepository(dDayRemoteDatasource);
}
