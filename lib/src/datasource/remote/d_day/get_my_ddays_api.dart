import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hummingbird/src/providers/dio_providers/dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_my_ddays_api.freezed.dart';
part 'get_my_ddays_api.g.dart';

@freezed
class DdayInfo with _$DdayInfo {
  const factory DdayInfo({
    required String ddayId,
    required String title,
    required String color,
    required int targetDatetime,
  }) = _DdayInfo;

  factory DdayInfo.fromJson(Map<String, dynamic> json) =>
      _$DdayInfoFromJson(json);
}

@freezed
class GetMyDdaysApiResDto with _$GetMyDdaysApiResDto {
  const factory GetMyDdaysApiResDto({
    required List<DdayInfo> ddays,
  }) = _GetMyDdaysApiResDto;

  factory GetMyDdaysApiResDto.fromJson(Map<String, dynamic> json) =>
      _$GetMyDdaysApiResDtoFromJson(json);
}

class GetMyDdaysApi {
  Dio dio;

  GetMyDdaysApi({required this.dio});

  Future<GetMyDdaysApiResDto> execute() async {
    final response = await dio.get('/dday');

    return GetMyDdaysApiResDto.fromJson(response.data);
  }
}

@riverpod
GetMyDdaysApi getMyDdaysApi(Ref ref) {
  final dio = ref.watch(dioProvider);

  return GetMyDdaysApi(dio: dio);
}
