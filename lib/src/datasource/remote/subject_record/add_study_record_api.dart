import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../providers/dio_providers/dio_provider.dart';

part 'add_study_record_api.freezed.dart';
part 'add_study_record_api.g.dart';

@freezed
class AddStudyRecordApiReqDto with _$AddStudyRecordApiReqDto {
  const factory AddStudyRecordApiReqDto({
    required String date,
    required int totalDuration,
    required String title,
    required int duration,
    required int startAt,
    required int endAt,
    required int totalBreak,
  }) = _AddStudyRecordApiReqDto;

  factory AddStudyRecordApiReqDto.fromJson(Map<String, dynamic> json) =>
      _$AddStudyRecordApiReqDtoFromJson(json);
}

class AddStudyRecordApi {
  Dio dio;

  AddStudyRecordApi({required this.dio});

  Future<void> execute(AddStudyRecordApiReqDto dto) async {
    await dio.put('/study-records', data: dto.toJson());
  }
}

@riverpod
AddStudyRecordApi addStudyRecordApi(Ref ref) {
  final dio = ref.watch(dioProvider);

  return AddStudyRecordApi(dio: dio);
}
