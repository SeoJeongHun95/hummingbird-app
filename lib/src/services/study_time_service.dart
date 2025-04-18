import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/grass/grass_data_model.dart';

class StudyTimeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 콜렉션 이름을 상수로 정의
  static const String _jandiCollection = 'jandi';
  static const String _studyTimesCollection = 'study_times';

  /// 사용자의 지난 16주간의 공부 시간 데이터를 가져옵니다.
  Future<List<GrassDataModel>> getStudyTimeData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not found');

      // 현재 날짜의 시작 (00:00:00)
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      print('Getting study time data for current date: $today');

      // 이전 달의 첫 번째 월요일을 구합니다
      final startOfPrevMonth = DateTime(now.year, now.month - 1, 1);
      var startDate = startOfPrevMonth;
      while (startDate.weekday != 1) {
        startDate = startDate.subtract(const Duration(days: 1));
      }

      final startTimestamp = startDate.millisecondsSinceEpoch ~/ 1000;
      print('Start date: $startDate');
      print('Start timestamp: $startTimestamp');

      final QuerySnapshot snapshot = await _firestore
          .collection(_jandiCollection)
          .doc(user.uid)
          .collection(_studyTimesCollection)
          .where('studyDay', isGreaterThanOrEqualTo: startTimestamp)
          .orderBy('studyDay', descending: true)
          .get();

      print('Retrieved ${snapshot.docs.length} documents');

      final result = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        print('Document data: $data');

        // studyDuration이 없는 경우 studyCount를 기반으로 계산 (이전 데이터 호환성)
        if (!data.containsKey('studyDuration') &&
            data.containsKey('studyCount')) {
          data['studyDuration'] =
              data['studyCount'] * 3600; // 1시간(3600초)을 기본값으로 설정
        }
        return GrassDataModel.fromJson(data);
      }).toList();

      print('Converted to ${result.length} GrassDataModel objects');
      for (var item in result) {
        print(
            'Model - Date: ${item.studyDay}, Duration: ${item.studyDuration}');
      }

      return result;
    } catch (e, stackTrace) {
      print('Error fetching study time data: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  /// 오늘의 공부 시간을 저장하거나 업데이트합니다.
  Future<void> updateTodayStudyTime(int studyDuration) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('Error: User not authenticated');
        throw Exception('User not found');
      }

      // 한국 시간 기준으로 새벽 6시 이전이면 전날로 처리
      final now = DateTime.now();
      final koreanTime = now.add(const Duration(hours: 9)); // UTC to KST
      final isBeforeSixAM = koreanTime.hour < 6;

      final DateTime startOfDay = isBeforeSixAM
          ? DateTime(now.year, now.month, now.day - 1)
          : DateTime(now.year, now.month, now.day);

      final int studyDay = startOfDay.millisecondsSinceEpoch ~/ 1000;

      print('Updating study time for user: ${user.uid}');
      print(
          'Collection path: $_jandiCollection/${user.uid}/$_studyTimesCollection');
      print('Date: $startOfDay');
      print('Study Day (timestamp): $studyDay');
      print('New Duration to add: $studyDuration seconds');

      // 문서 참조 생성
      final docRef = _firestore
          .collection(_jandiCollection)
          .doc(user.uid)
          .collection(_studyTimesCollection)
          .doc(studyDay.toString());

      // 현재 데이터 확인
      final docSnapshot = await docRef.get();
      int totalDuration = studyDuration;

      if (docSnapshot.exists) {
        final existingData = docSnapshot.data() as Map<String, dynamic>;
        print('Existing data: $existingData');
        // 기존 studyDuration이 있으면 더하기
        if (existingData.containsKey('studyDuration')) {
          totalDuration += existingData['studyDuration'] as int;
          print(
              'Adding to existing duration: ${existingData['studyDuration']} + $studyDuration = $totalDuration');
        }
      } else {
        print('No existing data for this date, creating new document');
      }

      // 데이터 저장
      final data = {
        'studyDay': studyDay,
        'studyDuration': totalDuration,
        'studyCount': (totalDuration / 3600).ceil(), // 이전 버전과의 호환성을 위해 유지
        'updatedAt': FieldValue.serverTimestamp(),
      };

      print('Saving data with total duration: $data');

      await docRef.set(data, SetOptions(merge: true));

      print(
          'Study time updated successfully with total duration: $totalDuration seconds');
    } catch (e, stackTrace) {
      print('Error updating study time: $e');
      print('Stack trace: $stackTrace');
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
          .collection(_jandiCollection)
          .doc(user.uid)
          .collection(_studyTimesCollection)
          .doc(studyDay.toString())
          .get();

      if (!doc.exists) return null;

      final data = doc.data() as Map<String, dynamic>;
      return GrassDataModel.fromJson(data);
    } catch (e, stackTrace) {
      print('Error fetching study time for date: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }
}
