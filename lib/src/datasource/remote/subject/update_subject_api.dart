import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../providers/dio_providers/dio_provider.dart';

part 'update_subject_api.freezed.dart';
part 'update_subject_api.g.dart';

@freezed
class UpdateSubjectApiReqDto with _$UpdateSubjectApiReqDto {
  const factory UpdateSubjectApiReqDto({
    required String subjectId,
    String? title,
    String? color,
    String? order,
  }) = _UpdateSubjectApiReqDto;

  factory UpdateSubjectApiReqDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateSubjectApiReqDtoFromJson(json);
}

class UpdateSubjectApi {
  Dio dio;

  UpdateSubjectApi({required this.dio});

  Future<void> execute(UpdateSubjectApiReqDto dto) async {
    await dio.patch('/subjects/${dto.subjectId}', data: dto.toJson());
  }
}

@riverpod
UpdateSubjectApi updateSubjectApi(Ref ref) {
  final dio = ref.watch(dioProvider);

  return UpdateSubjectApi(dio: dio);
}
