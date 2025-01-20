import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../providers/dio_providers/dio_provider.dart';

part 'delete_subject_api.g.dart';

class DeleteSubjectApi {
  Dio dio;

  DeleteSubjectApi({required this.dio});

  Future<void> execute({required String subjectId}) async {
    await dio.delete('/subjects/$subjectId');
  }
}

@riverpod
DeleteSubjectApi deleteSubjectApi(Ref ref) {
  final dio = ref.watch(dioProvider);

  return DeleteSubjectApi(dio: dio);
}
