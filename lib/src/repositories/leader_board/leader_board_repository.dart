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
    Map<String, dynamic> result = {};

    result = await _remoteDataSource
        .getLeaderboard(formatDate(DateTime.now().subtract(Duration(days: 1))));

    return result;
  }
}
