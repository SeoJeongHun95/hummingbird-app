import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../datasource/remote/study_record/study_record_remote_datasource.dart';
import '../../models/study_record/study_record.dart';

final studyRecordRepositoryProvider = Provider<StudyRecordRepository>((ref) {
  return StudyRecordRepository(StudyRecordDataSource());
});

class StudyRecordRepository {
  final StudyRecordDataSource _remoteDataSource;

  StudyRecordRepository(this._remoteDataSource);

  Future<void> addStudyRecord(StudyRecord studyRecord) async {
    _remoteDataSource.addStudyRecord(studyRecord);
  }

  Future<List<StudyRecord>> getMonthlyStudyRecords(String yearMonth) async {
    return await _remoteDataSource.getMonthlyStudyRecords(yearMonth);
  }

  Future<List<StudyRecord>> getStudyRecord() async {
    String monthKey = DateFormat('yyyy-MM').format(DateTime.now());
    return await _remoteDataSource.getMonthlyStudyRecords(monthKey);
  }
}
