import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../datasource/remote/subject/subject_remote_datasource.dart';
import '../../models/subject/subject.dart';

final subjectRepositoryProvider = Provider<SubjectRepository>((ref) {
  return SubjectRepository(SubjectRemoteDataSource());
});

// @riverpod
// SubjectRepository subjectRepository(Ref ref) {
//   return SubjectRepository(SubjectRemoteDataSource());
// }

class SubjectRepository {
  final SubjectRemoteDataSource _remoteDataSource;

  SubjectRepository(this._remoteDataSource);

  Future<List<Subject>> addSubject(Subject subject) async {
    await _remoteDataSource.addSubject(subject);
    return await getAllSubjects();
  }

  Future<List<Subject>> getAllSubjects() async {
    return await _remoteDataSource.getAllSubjects();
  }

  Future<List<Subject>> updateSubject(Subject updatedSubject) async {
    await _remoteDataSource.updateSubject(updatedSubject);

    return await getAllSubjects();
  }

  Future<void> deleteSubject(String subjectId) async {
    await _remoteDataSource.deleteSubject(subjectId);
  }
}
