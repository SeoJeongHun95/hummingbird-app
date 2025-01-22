import 'create_subject_api.dart';
import 'delete_subject_api.dart';
import 'get_subjects_api.dart';
import 'update_subject_api.dart';

class SubjectRemoteDatasource {
  CreateSubjectApi createSubjectApi;
  GetSubjectsApi getSubjectsApi;
  UpdateSubjectApi updateSubjectApi;
  DeleteSubjectApi deleteSubjectApi;

  SubjectRemoteDatasource({
    required this.createSubjectApi,
    required this.getSubjectsApi,
    required this.updateSubjectApi,
    required this.deleteSubjectApi,
  });
}
