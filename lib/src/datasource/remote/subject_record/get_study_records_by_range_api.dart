import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hummingbird/src/datasource/remote/subject_record/get_study_record_by_date_api.dart';
import 'package:hummingbird/src/providers/dio_providers/dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_study_records_by_range_api.freezed.dart';
part 'get_study_records_by_range_api.g.dart';

@freezed
class GetStudyRecordsByRangeApiReqDto with _$GetStudyRecordsByRangeApiReqDto {
  const factory GetStudyRecordsByRangeApiReqDto({
    required int userId,
    required String startDate,
    required String endDate,
  }) = _GetStudyRecordsByRangeApiReqDto;

  factory GetStudyRecordsByRangeApiReqDto.fromJson(Map<String, dynamic> json) =>
      _$GetStudyRecordsByRangeApiReqDtoFromJson(json);
}

@freezed
class GetStudyRecordsByRangeApiResDto with _$GetStudyRecordsByRangeApiResDto {
  const factory GetStudyRecordsByRangeApiResDto(
          {required List<StudyRecordInfo> studyRecords}) =
      _GetStudyRecordsByRangeApiResDto;

  factory GetStudyRecordsByRangeApiResDto.fromJson(Map<String, dynamic> json) =>
      _$GetStudyRecordsByRangeApiResDtoFromJson(json);
}

@freezed
class StudyRecordInfo with _$StudyRecordInfo {
  const factory StudyRecordInfo({
    required String date,
    required int goalDuration,
    required int totalDuration,
    required List<StudyInfo> studies,
  }) = _StudyRecordInfo;

  factory StudyRecordInfo.fromJson(Map<String, dynamic> json) =>
      _$StudyRecordInfoFromJson(json);
}

class GetStudyRecordsByRangeApi {
  Dio dio;

  GetStudyRecordsByRangeApi({required this.dio});

  Future<GetStudyRecordsByRangeApiResDto> execute(
      GetStudyRecordsByRangeApiReqDto dto) async {
    final response = await dio.get(
        '/study-records/range?userId=${dto.userId}&startDate=${dto.startDate}&endDate=${dto.endDate}');

    return GetStudyRecordsByRangeApiResDto.fromJson(response.data);
  }
}

@riverpod
GetStudyRecordsByRangeApi getStudyRecordsByRangeApi(Ref ref) {
  final dio = ref.watch(dioProvider);

  return GetStudyRecordsByRangeApi(dio: dio);
}
