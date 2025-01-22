import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../providers/dio_providers/dio_provider.dart';

part 'get_study_record_by_date_api.freezed.dart';
part 'get_study_record_by_date_api.g.dart';

@freezed
class GetStudyRecordByDateReqDto with _$GetStudyRecordByDateReqDto {
  const factory GetStudyRecordByDateReqDto({
    required int userId,
    required String date,
  }) = _GetStudyRecordByDateReqDto;

  factory GetStudyRecordByDateReqDto.fromJson(Map<String, dynamic> json) =>
      _$GetStudyRecordByDateReqDtoFromJson(json);
}

@freezed
class GetStudyRecordByDateResDto with _$GetStudyRecordByDateResDto {
  const factory GetStudyRecordByDateResDto({
    required int totalDuration,
    required List<StudyInfo> studies,
  }) = _GetStudyRecordByDateResDto;

  factory GetStudyRecordByDateResDto.fromJson(Map<String, dynamic> json) =>
      _$GetStudyRecordByDateResDtoFromJson(json);
}

@freezed
class StudyInfo with _$StudyInfo {
  const factory StudyInfo({
    required String title,
    required int duration,
    required int totalBreak,
    required int startAt,
    required int endAt,
  }) = _StudyInfo;

  factory StudyInfo.fromJson(Map<String, dynamic> json) =>
      _$StudyInfoFromJson(json);
}

class GetStudyRecordByDateApi {
  Dio dio;

  GetStudyRecordByDateApi({required this.dio});

  Future<GetStudyRecordByDateResDto?> execute(
      GetStudyRecordByDateReqDto dto) async {
    final response =
        await dio.get('/study-records?userId=${dto.userId}&date=${dto.date}');

    if (response.data == null) {
      return null;
    }

    return GetStudyRecordByDateResDto.fromJson(response.data);
  }
}

@riverpod
GetStudyRecordByDateApi getStudyRecordByDateApi(Ref ref) {
  final dio = ref.watch(dioProvider);

  return GetStudyRecordByDateApi(dio: dio);
}
