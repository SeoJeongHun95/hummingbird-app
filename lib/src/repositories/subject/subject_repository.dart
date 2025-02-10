import '../../datasource/local/subject/subject_local_datasource.dart';
import '../../models/subject/subject.dart';

class SubjectRepository {
  final SubjectDataSource _localDataSource;

  SubjectRepository(this._localDataSource);

  Future<List<Subject>> addSubject(Subject subject) async {
    await _localDataSource.addSubject(subject);

    return await getAllSubjects();
  }

  Future<List<Subject>> getAllSubjects() async {
    return await _localDataSource.getAllSubjects();
  }

  Future<List<Subject>> updateSubject(int index, Subject updatedSubject) async {
    _localDataSource.updateSubject(index, updatedSubject);

    return await getAllSubjects();
  }

  Future<void> deleteSubject(int index) async {
    _localDataSource.deleteSubject(index);
  }
}
