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
  StudyRecordRepository(this.localDataSource);

  final StudyRecordDataSource localDataSource;

  Future<void> addStudyRecord(StudyRecord studyRecord) async {
    await localDataSource.addStudyRecord(studyRecord);
  }

  Future<Map<String, List<StudyRecord>>> getStudyRecord() async {
    return localDataSource.getStudyRecord();
  }

  Future<void> updateStudyRecord(StudyRecord studyRecord) async {
    await localDataSource.updateStudyRecord(studyRecord);
  }

  Future<void> deleteStudyRecord() async {
    await localDataSource.deleteStudyRecord();
  }
}
