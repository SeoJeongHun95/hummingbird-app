import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardRemoteDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final tmpdateKey = "2025-03-12";

  Future<Map<String, dynamic>> getLeaderboard(String dateKey) async {
    try {
      DocumentSnapshot leaderboardSnapshot = await _firestore
          .collection('Leaderboard')
          .doc(tmpdateKey)
          .get(); // dateKey를 사용

      if (leaderboardSnapshot.exists) {
        return leaderboardSnapshot.data() as Map<String, dynamic>;
      } else {
        throw Exception('No leaderboard data found for $dateKey');
      }
    } catch (e) {
      throw Exception('Error fetching leaderboard data: $e');
    }
  }
}
