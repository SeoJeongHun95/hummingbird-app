import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/grass/grass_data_model.dart';

class StudyTimeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 사용자의 지난 16주간의 공부 시간 데이터를 가져옵니다.
  Future<List<GrassDataModel>> getStudyTimeData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not found');

      // 16주 전 날짜 계산
      final DateTime sixteenWeeksAgo =
          DateTime.now().subtract(const Duration(days: 16 * 7));

      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('study_times')
          .where('studyDay',
              isGreaterThanOrEqualTo:
                  sixteenWeeksAgo.millisecondsSinceEpoch ~/ 1000)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return GrassDataModel.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error fetching study time data: $e');
      return [];
    }
  }

  /// 오늘의 공부 시간을 저장하거나 업데이트합니다.
  Future<void> updateTodayStudyTime(int studyCount) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not found');

      // 오늘 날짜의 시작 시간 (00:00:00)
      final DateTime today = DateTime.now();
      final DateTime startOfDay = DateTime(today.year, today.month, today.day);
      final int studyDay = startOfDay.millisecondsSinceEpoch ~/ 1000;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('study_times')
          .doc(studyDay.toString())
          .set({
        'studyDay': studyDay,
        'studyCount': studyCount,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error updating study time: $e');
      rethrow;
    }
  }
}
