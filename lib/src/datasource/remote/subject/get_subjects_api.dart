import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../providers/dio_providers/dio_provider.dart';

part 'get_subjects_api.freezed.dart';
part 'get_subjects_api.g.dart';

@freezed
class SubjectInfo with _$SubjectInfo {
  const factory SubjectInfo({
    required String subjectId,
    required String title,
    required String color,
    required int order,
    required DateTime updatedAt,
  }) = _SubjectInfo;

  factory SubjectInfo.fromJson(Map<String, dynamic> json) =>
      _$SubjectInfoFromJson(json);
}

@freezed
class GetSubjectsApiResDto with _$GetSubjectsApiResDto {
  const factory GetSubjectsApiResDto({required List<SubjectInfo> subjects}) =
      _GetSubjectsApiResDto;

  factory GetSubjectsApiResDto.fromJson(Map<String, dynamic> json) =>
      _$GetSubjectsApiResDtoFromJson(json);
}

class GetSubjectsApi {
  Dio dio;

  GetSubjectsApi({required this.dio});

  Future<GetSubjectsApiResDto> execute({required int userId}) async {
    final response = await dio.get('/subjects/users/$userId');

    return GetSubjectsApiResDto.fromJson(response.data);
  }
}

@riverpod
GetSubjectsApi getSubjectsApi(Ref ref) {
  final dio = ref.watch(dioProvider);

  return GetSubjectsApi(dio: dio);
}
