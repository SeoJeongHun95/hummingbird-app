import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/const/box_keys.dart';
import '../../datasource/local/subject_local_datasource/subject_local_datasource.dart';
import '../../models/study_record/subject/subject.dart';

part 'subject_repository.g.dart';

@riverpod
SubjectRepository subjectRepository(Ref ref) {
  final box = Hive.box<Subject>(BoxKeys.subjectBoxKey);
  final subjectLocalDataSource = SubjectDataSource(box);
  return SubjectRepository(subjectLocalDataSource);
}

class SubjectRepository {
  SubjectRepository(this.localDataSource);

  final SubjectDataSource localDataSource;

  // 로컬 데이터 소스에 과목 추가
  Future<List<Subject>> addSubject(Subject subject) async {
    await localDataSource.addSubject(subject);
    return await getAllSubjects(); // 갱신된 리스트 반환
  }

  // 로컬 데이터 소스에서 모든 과목 가져오기
  Future<List<Subject>> getAllSubjects() async {
    // TODO: 원격 데이터 소스 통합
    return localDataSource.getAllSubjects();
  }

  // 로컬 데이터 소스에서 과목 업데이트
  Future<void> updateSubject(int index, Subject updatedSubject) async {
    // TODO: 원격 데이터 소스 통합
    return localDataSource.updateSubject(index, updatedSubject);
  }

  // 로컬 데이터 소스에서 과목 삭제
  Future<void> deleteSubject(int index) async {
    // TODO: 원격 데이터 소스 통합
    return localDataSource.deleteSubject(index);
  }
}
