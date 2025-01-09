import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/const/box_keys.dart';
import '../../datasource/local/study_record/study_record_local_datasource.dart';
import '../../models/study_record/study_record.dart';

part 'study_record_repository.g.dart';

@riverpod
StudyRecordRepository studyRecordRepository(Ref ref) {
  final box = Hive.box<StudyRecord>(BoxKeys.studyRecordBoxkey);
  final studyRecordLocalDataSource = StudyRecordDataSource(box);
  return StudyRecordRepository(studyRecordLocalDataSource);
}

class StudyRecordRepository {
  StudyRecordRepository(this.localDataSource);

  final StudyRecordDataSource localDataSource;

  // 로컬 데이터 소스에 스터디 기록 추가
  Future<List<StudyRecord>> addStudyRecord(StudyRecord studyRecord) async {
    await localDataSource.addStudyRecord(studyRecord);
    return await getAllStudyRecords(); // 갱신된 리스트 반환
  }

  // 로컬 데이터 소스에서 모든 스터디 기록 가져오기
  Future<List<StudyRecord>> getAllStudyRecords() async {
    // TODO: 원격 데이터 소스 통합
    return localDataSource.getAllStudyRecords();
  }
}
