import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hummingbird/src/providers/dio_providers/dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_dday_api.freezed.dart';
part 'create_dday_api.g.dart';

@freezed
class CreateDdayApiReqDto with _$CreateDdayApiReqDto {
  const factory CreateDdayApiReqDto({
    required String title,
    required String color,
    required int targetDatetime,
  }) = _CreateDdayApiReqDto;

  factory CreateDdayApiReqDto.fromJson(Map<String, dynamic> json) =>
      _$CreateDdayApiReqDtoFromJson(json);
}

@freezed
class CreateDdayApiResDto with _$CreateDdayApiResDto {
  const factory CreateDdayApiResDto({
    required String ddayId,
  }) = _CreateDdayApiResDto;

  factory CreateDdayApiResDto.fromJson(Map<String, dynamic> json) =>
      _$CreateDdayApiResDtoFromJson(json);
}

class CreateDdayApi {
  Dio dio;

  CreateDdayApi({required this.dio});

  Future<CreateDdayApiResDto> execute(CreateDdayApiReqDto dto) async {
    final response = await dio.post('/dday', data: dto.toJson());

    return CreateDdayApiResDto.fromJson(response.data);
  }
}

@riverpod
CreateDdayApi createDdayApi(Ref ref) {
  final dio = ref.watch(dioProvider);

  return CreateDdayApi(dio: dio);
}
