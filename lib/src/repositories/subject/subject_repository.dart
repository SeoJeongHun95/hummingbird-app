import 'package:hummingbird/src/datasource/remote/subject/update_subject_api.dart';

import '../../datasource/local/subject/subject_local_datasource.dart';
import '../../datasource/remote/subject/create_subject_api.dart';
import '../../datasource/remote/subject_record/subject_remote_datasource.dart';
import '../../models/subject/subject.dart';

class SubjectRepository {
  final SubjectDataSource _localDataSource;
  final SubjectRemoteDatasource _remoteDatasource;

  SubjectRepository(this._localDataSource, this._remoteDatasource);

  Future<List<Subject>> addSubject(Subject subject, bool isConnected) async {
    final res = await _remoteDatasource.createSubjectApi.execute(
        CreateSubjectApiReqDto(
            title: subject.title, color: subject.color, order: subject.order));

    await _localDataSource
        .addSubject(subject.copyWith(subjectId: res.subjectId));

    return await getAllSubjects(isConnected);
  }

  Future<List<Subject>> getAllSubjects(bool isConnected) async {
    final localSubjectList = await _localDataSource.getAllSubjects();

    if (localSubjectList.isNotEmpty) {
      return localSubjectList;
    }

    if (isConnected) {
      final subjectsInfo =
          await _remoteDatasource.getSubjectsApi.execute(userId: 25);
      if (subjectsInfo.subjects.isNotEmpty) {
        final subjectsList = subjectsInfo.subjects
            .map((subjectInfo) => Subject(
                  subjectId: subjectInfo.subjectId,
                  title: subjectInfo.title,
                  color: subjectInfo.color,
                  order: subjectInfo.order,
                ))
            .toList();
        return subjectsList;
      }
    }

    return localSubjectList;
  }

  Future<List<Subject>> updateSubject(
      int index, Subject updatedSubject, bool isConnected) async {
    if (updatedSubject.subjectId == null) {
      return await getAllSubjects(isConnected);
    }

    await _remoteDatasource.updateSubjectApi.execute(
      UpdateSubjectApiReqDto(
        subjectId: updatedSubject.subjectId!,
        title: updatedSubject.title,
        color: updatedSubject.color,
        order: updatedSubject.order,
      ),
    );
    _localDataSource.updateSubject(index, updatedSubject);

    return await getAllSubjects(isConnected);
  }

  Future<void> deleteSubject(String subjectId, int index) async {
    await _remoteDatasource.deleteSubjectApi.execute(subjectId: subjectId);
    _localDataSource.deleteSubject(index);
  }
}
