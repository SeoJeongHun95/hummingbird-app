import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/const/box_keys.dart';
import '../../datasource/local/subject/subject_local_datasource.dart';
import '../../datasource/remote/subject/create_subject_api.dart';
import '../../datasource/remote/subject/delete_subject_api.dart';
import '../../datasource/remote/subject/get_subjects_api.dart';
import '../../datasource/remote/subject/subject_remote_datasource.dart';
import '../../datasource/remote/subject/update_subject_api.dart';
import '../../models/subject/subject.dart';
import '../../repositories/subject/subject_repository.dart';

part 'subject_repository_provider.g.dart';

@Riverpod(keepAlive: true)
SubjectRepository subjectRepository(Ref ref) {
  final box = Hive.box<Subject>(BoxKeys.subjectBoxKey);
  final subjectLocalDatasource = SubjectDataSource(box);
  final createSubjectApi = ref.watch(createSubjectApiProvider);
  final getSubjectsApi = ref.watch(getSubjectsApiProvider);
  final updateSubjectApi = ref.watch(updateSubjectApiProvider);
  final deleteSubjectApi = ref.watch(deleteSubjectApiProvider);
  final subjectRemoteDatasource = SubjectRemoteDatasource(
      createSubjectApi: createSubjectApi,
      getSubjectsApi: getSubjectsApi,
      updateSubjectApi: updateSubjectApi,
      deleteSubjectApi: deleteSubjectApi);

  return SubjectRepository(subjectLocalDatasource, subjectRemoteDatasource);
}
