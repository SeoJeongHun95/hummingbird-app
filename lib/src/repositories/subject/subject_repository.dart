import '../../datasource/local/subject/subject_local_datasource.dart';
import '../../datasource/remote/subject_record/subject_remote_datasource.dart';
import '../../models/subject/subject.dart';

class SubjectRepository {
  final SubjectDataSource localDataSource;
  final SubjectRemoteDatasource remoteDatasource;

  SubjectRepository(this.localDataSource, this.remoteDatasource);

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
