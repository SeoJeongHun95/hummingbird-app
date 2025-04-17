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

      // 현재 날짜의 시작 (00:00:00)
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      print('Getting study time data for current date: $today'); // 디버그 로그 추가

      // 이전 달의 첫 번째 월요일을 구합니다
      final startOfPrevMonth = DateTime(now.year, now.month - 1, 1);
      var startDate = startOfPrevMonth;
      while (startDate.weekday != 1) {
        startDate = startDate.subtract(const Duration(days: 1));
      }

      final startTimestamp = startDate.millisecondsSinceEpoch ~/ 1000;
      print('Start date: $startDate'); // 디버그 로그 추가
      print('Start timestamp: $startTimestamp'); // 디버그 로그 추가

      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('study_times')
          .where('studyDay', isGreaterThanOrEqualTo: startTimestamp)
          .orderBy('studyDay', descending: true)
          .get();

      print('Retrieved ${snapshot.docs.length} documents'); // 디버그 로그 추가

      final result = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        print('Document data: $data'); // 디버그 로그 추가

        // studyDuration이 없는 경우 studyCount를 기반으로 계산 (이전 데이터 호환성)
        if (!data.containsKey('studyDuration') &&
            data.containsKey('studyCount')) {
          data['studyDuration'] =
              data['studyCount'] * 3600; // 1시간(3600초)을 기본값으로 설정
        }
        return GrassDataModel.fromJson(data);
      }).toList();

      print(
          'Converted to ${result.length} GrassDataModel objects'); // 디버그 로그 추가
      for (var item in result) {
        print(
            'Model - Date: ${item.studyDay}, Duration: ${item.studyDuration}');
      }

      return result;
    } catch (e) {
      print('Error fetching study time data: $e');
      return [];
    }
  }

  /// 오늘의 공부 시간을 저장하거나 업데이트합니다.
  Future<void> updateTodayStudyTime(int studyDuration) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not found');

      // 오늘 날짜의 시작 시간 (00:00:00)
      final DateTime today = DateTime.now();
      final DateTime startOfDay = DateTime(today.year, today.month, today.day);
      final int studyDay = startOfDay.millisecondsSinceEpoch ~/ 1000;

      print('Updating study time:'); // 디버그 로그 추가
      print('Date: $startOfDay');
      print('Study Day (timestamp): $studyDay');
      print('Duration: $studyDuration seconds');

      final docRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('study_times')
          .doc(studyDay.toString());

      // 현재 데이터 확인
      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        print('Existing data: ${docSnapshot.data()}');
      } else {
        print('No existing data for this date');
      }

      await docRef.set({
        'studyDay': studyDay,
        'studyDuration': studyDuration,
        'studyCount': (studyDuration / 3600).ceil(), // 이전 버전과의 호환성을 위해 유지
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print('Study time updated successfully');
    } catch (e) {
      print('Error updating study time: $e');
      rethrow;
    }
  }

  /// 특정 날짜의 공부 시간을 가져옵니다.
  Future<GrassDataModel?> getStudyTimeForDate(DateTime date) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not found');

      final DateTime startOfDay = DateTime(date.year, date.month, date.day);
      final int studyDay = startOfDay.millisecondsSinceEpoch ~/ 1000;

      final DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('study_times')
          .doc(studyDay.toString())
          .get();

      if (!doc.exists) return null;

      final data = doc.data() as Map<String, dynamic>;
      return GrassDataModel.fromJson(data);
    } catch (e) {
      print('Error fetching study time for date: $e');
      return null;
    }
  }
}
