import 'package:StudyDuck/core/utils/format_date.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../datasource/local/study_record/study_record_local_datasource.dart';
import '../../models/study_record/study_record.dart';

part 'study_record_repository.g.dart';

@riverpod
StudyRecordRepository studyRecordRepository(Ref ref) {
  final studyRecordLocalDataSource = StudyRecordDataSource();

  return StudyRecordRepository(studyRecordLocalDataSource);
}

class StudyRecordRepository {
  final StudyRecordDataSource _localDataSource;

  StudyRecordRepository(this._localDataSource);

  Future<void> addStudyRecord(StudyRecord studyRecord, int totduration) async {
    await _localDataSource.addStudyRecord(studyRecord);
  }

  Future<Map<String, List<StudyRecord>>> getStudyRecord(
      int userId, bool isConnected) async {
    return _localDataSource.getStudyRecord();
  }

  Future<Map<String, List<StudyRecord>>> getStudyRecordByDate(
      String date) async {
    return _localDataSource.getStudyRecordByDate(date);
  }

  Future<Map<String, List<StudyRecord>>> getStudyRecordByRange(
      int userId,
      DateTime startDate,
      DateTime endDate,
      int period,
      bool isConnected) async {
    Map<String, List<StudyRecord>> studyRecordMap = {};
    for (int i = 0; i < period; i++) {
      final date = formatDate(startDate.add(Duration(days: i)));
      final studyRecord = await getStudyRecordByDate(
          formatDate(startDate.add(Duration(days: i))));

      studyRecordMap[date] = studyRecord[date] ?? [];
    }

    return studyRecordMap;
  }

  Future<void> updateStudyRecord(StudyRecord studyRecord) async {
    await _localDataSource.updateStudyRecord(studyRecord);
  }

  Future<void> deleteStudyRecord() async {
    await _localDataSource.deleteStudyRecord();
  }
}
