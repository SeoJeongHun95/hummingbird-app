import 'add_study_record_api.dart';
import 'get_study_record_by_date_api.dart';
import 'get_study_records_by_range_api.dart';

class StudyRecordRemoteDatasource {
  AddStudyRecordApi addStudyRecordApi;
  GetStudyRecordByDateApi getStudyRecordByDateApi;
  GetStudyRecordsByRangeApi getStudyRecordsByRangeApi;

  StudyRecordRemoteDatasource({
    required this.addStudyRecordApi,
    required this.getStudyRecordByDateApi,
    required this.getStudyRecordsByRangeApi,
  });
}
