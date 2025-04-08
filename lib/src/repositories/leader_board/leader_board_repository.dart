import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/format_date.dart';
import '../../datasource/remote/leader_board/leader_board_remote_datasource.dart';

final leaderboardRepositoryProvider = Provider<LeaderboardRepository>((ref) {
  return LeaderboardRepository(LeaderboardRemoteDatasource());
});

class LeaderboardRepository {
  final LeaderboardRemoteDatasource _remoteDataSource;

  LeaderboardRepository(this._remoteDataSource);

  Future<Map<String, dynamic>> getLeaderboard() async {
    DateTime now = DateTime.now().subtract(const Duration(hours: 6));

    DateTime targetDate = now.hour < 6
        ? now.subtract(Duration(days: 1))
        : now.subtract(Duration(days: 2));

    final dateKey = formatDate(targetDate);

    final result = await _remoteDataSource.getLeaderboard(dateKey);
    return result;
  }
}
