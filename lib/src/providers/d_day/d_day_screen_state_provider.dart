import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hummingbird/src/viewmodels/d_day/d_day_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/d_day/d_day.dart';
import '../network_status/network_state_provider.dart';

part 'd_day_screen_state_provider.g.dart';

@riverpod
Future<(List<DDay>, bool)> dDayScreenState(Ref ref) async {
  final networkStatus = await ref.watch(networkStateProvider.future);
  final dDays = await ref.watch(dDayViewModelProvider.future);

  return (dDays, networkStatus);
}
