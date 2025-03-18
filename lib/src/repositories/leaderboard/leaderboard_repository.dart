import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/format_date.dart';
import '../../datasource/remote/leaderboard/leaderboard_remote_datasource.dart';

final leaderboardRepositoryProvider = Provider<LeaderboardRepository>((ref) {
  return LeaderboardRepository(LeaderboardRemoteDatasource());
});

class LeaderboardRepository {
  final LeaderboardRemoteDatasource _remoteDataSource;

  LeaderboardRepository(this._remoteDataSource);

  Future<Map<String, dynamic>> getLeaderboard() async {
    Map<String, dynamic> result = {};

    result =
        await _remoteDataSource.fetchLeaderboard(formatDate(DateTime.now()));

    return result;
  }
}
