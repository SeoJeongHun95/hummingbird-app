import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/const/box_keys.dart';
import '../../datasource/local/subject/subject_local_datasource.dart';
import '../../models/subject/subject.dart';
import '../../repositories/subject/subject_repository.dart';

part 'subject_repository_provider.g.dart';

@Riverpod(keepAlive: true)
SubjectRepository subjectRepository(Ref ref) {
  final box = Hive.box<Subject>(BoxKeys.subjectBoxKey);
  final subjectLocalDatasource = SubjectDataSource(box);
  return SubjectRepository(subjectLocalDatasource);
}
