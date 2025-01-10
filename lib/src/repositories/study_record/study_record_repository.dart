import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/const/box_keys.dart';
import '../../datasource/local/study_record/study_record_local_datasource.dart';
import '../../models/study_record/study_record.dart';

part 'study_record_repository.g.dart';

@riverpod
StudyRecordRepository studyRecordRepository(Ref ref) {
  final box = Hive.box<List<StudyRecord>>(BoxKeys.studyRecordBoxkey);
  final studyRecordLocalDataSource = StudyRecordDataSource(box);
  return StudyRecordRepository(studyRecordLocalDataSource);
}

class StudyRecordRepository {
  StudyRecordRepository(this.localDataSource);

  final StudyRecordDataSource localDataSource;

  Future<void> addStudyRecord(String date, StudyRecord studyRecord) async {
    await localDataSource.addStudyRecord(date, studyRecord);
  }

  Future<List<StudyRecord>> getStudyRecordsByDate(String date) async {
    return localDataSource.getStudyRecordsByDate(date);
  }

  Future<void> updateStudyRecord(
      String date, StudyRecord updatedStudyRecord) async {
    await localDataSource.updateStudyRecord(date, updatedStudyRecord);
  }
}
