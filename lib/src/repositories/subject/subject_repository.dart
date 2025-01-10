import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/const/box_keys.dart';
import '../../datasource/local/subject/subject_local_datasource.dart';
import '../../models/subject/subject.dart';

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

  Future<List<Subject>> addSubject(Subject subject) async {
    await localDataSource.addSubject(subject);
    return await getAllSubjects();
  }

  Future<List<Subject>> getAllSubjects() async {
    return localDataSource.getAllSubjects();
  }

  Future<void> updateSubject(int index, Subject updatedSubject) async {
    return localDataSource.updateSubject(index, updatedSubject);
  }

  Future<void> deleteSubject(int index) async {
    return localDataSource.deleteSubject(index);
  }
}
