import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardRemoteDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> fetchLeaderboard(String dateKey) async {
    try {
      DocumentSnapshot leaderboardSnapshot =
          await _firestore.collection('Leaderboard').doc(dateKey).get();

      if (leaderboardSnapshot.exists) {
        return leaderboardSnapshot.data() as Map<String, dynamic>;
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception();
    }
  }
}
