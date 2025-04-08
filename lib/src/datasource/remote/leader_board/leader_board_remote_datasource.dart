import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardRemoteDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getLeaderboard(String dateKey) async {
    print(dateKey);

    try {
      DocumentSnapshot leaderboardSnapshot = await _firestore
          .collection('Leaderboard')
          .doc(dateKey)
          .get(); // dateKey를 사용

      if (leaderboardSnapshot.exists) {
        return leaderboardSnapshot.data() as Map<String, dynamic>;
      } else {
        return {};
      }
    } catch (e) {
      throw Exception('Error fetching leaderboard data: $e');
    }
  }
}
