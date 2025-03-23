import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../repositories/leader_board/leader_board_repository.dart';

part 'leader_board_view_model_view_model.g.dart';

@riverpod
class LeaderBoardViewModel extends _$LeaderBoardViewModel {
  late LeaderboardRepository repository;

  @override
  AsyncValue<Map<String, dynamic>> build() {
    repository = ref.watch(leaderboardRepositoryProvider);
    state = const AsyncValue.loading();
    getLeaderboard();
    return state;
  }

  Future<void> getLeaderboard() async {
    final leaderboardData =
        await AsyncValue.guard(() => repository.getLeaderboard());
    state = leaderboardData;
  }
}
