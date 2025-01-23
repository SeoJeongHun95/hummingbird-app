import '../../datasource/local/subject/subject_local_datasource.dart';
import '../../datasource/remote/subject/create_subject_api.dart';
import '../../datasource/remote/subject/subject_remote_datasource.dart';
import '../../datasource/remote/subject/update_subject_api.dart';
import '../../models/subject/subject.dart';

class SubjectRepository {
  final SubjectDataSource _localDataSource;
  final SubjectRemoteDatasource _remoteDatasource;

  SubjectRepository(this._localDataSource, this._remoteDatasource);

  Future<List<Subject>> addSubject(
      int userId, Subject subject, bool isConnected) async {
    final res = await _remoteDatasource.createSubjectApi.execute(
        CreateSubjectApiReqDto(
            title: subject.title, color: subject.color, order: subject.order));

    await _localDataSource
        .addSubject(subject.copyWith(subjectId: res.subjectId));

    return await getAllSubjects(userId, isConnected);
  }

  Future<List<Subject>> getAllSubjects(int userId, bool isConnected) async {
    if (isConnected) {
      final subjectsInfo =
          await _remoteDatasource.getSubjectsApi.execute(userId: userId);
      return subjectsInfo.subjects.isNotEmpty
          ? subjectsInfo.subjects
              .map((subjectInfo) => Subject(
                    subjectId: subjectInfo.subjectId,
                    title: subjectInfo.title,
                    color: subjectInfo.color,
                    order: subjectInfo.order,
                  ))
              .toList()
          : [];
    } else {
      return await _localDataSource.getAllSubjects();
    }
  }

  Future<List<Subject>> updateSubject(
      int index, Subject updatedSubject, bool isConnected, int userId) async {
    if (updatedSubject.subjectId == null) {
      return await getAllSubjects(userId, isConnected);
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

    return await getAllSubjects(userId, isConnected);
  }

  Future<void> deleteSubject(String subjectId, int index) async {
    await _remoteDatasource.deleteSubjectApi.execute(subjectId: subjectId);
    _localDataSource.deleteSubject(index);
  }
}
