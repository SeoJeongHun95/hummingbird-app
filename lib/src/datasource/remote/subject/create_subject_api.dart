import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hummingbird/src/providers/dio_providers/dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_subject_api.freezed.dart';
part 'create_subject_api.g.dart';

@freezed
class CreateSubjectApiReqDto with _$CreateSubjectApiReqDto {
  const factory CreateSubjectApiReqDto({
    required String title,
    required String color,
    required int order,
  }) = _CreateSubjectApiReqDto;

  factory CreateSubjectApiReqDto.fromJson(Map<String, dynamic> json) =>
      _$CreateSubjectApiReqDtoFromJson(json);
}

@freezed
class CreateSubjectApiResDto with _$CreateSubjectApiResDto {
  const factory CreateSubjectApiResDto({
    required String subjectId,
  }) = _CreateSubjectApiResDto;

  factory CreateSubjectApiResDto.fromJson(Map<String, dynamic> json) =>
      _$CreateSubjectApiResDtoFromJson(json);
}

class CreateSubjectApi {
  Dio dio;

  CreateSubjectApi({required this.dio});

  Future<CreateSubjectApiResDto> execute(CreateSubjectApiReqDto dto) async {
    final response = await dio.post('/subjects', data: dto.toJson());

    return CreateSubjectApiResDto.fromJson(response.data);
  }
}

@riverpod
CreateSubjectApi createSubjectApi(Ref ref) {
  final dio = ref.watch(dioProvider);

  return CreateSubjectApi(dio: dio);
}
