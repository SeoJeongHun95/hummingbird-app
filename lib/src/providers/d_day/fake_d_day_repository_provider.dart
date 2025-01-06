import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../repositories/d_day/fake_d_day_repository.dart';

part 'fake_d_day_repository_provider.g.dart';

@riverpod
FakeDDayRepository fakeDDayRepository(Ref ref) {
  return FakeDDayRepository();
}
