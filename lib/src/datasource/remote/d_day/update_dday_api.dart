import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../providers/dio_providers/dio_provider.dart';

part 'update_dday_api.freezed.dart';
part 'update_dday_api.g.dart';

@freezed
class UpdateDdayApiReqDto with _$UpdateDdayApiReqDto {
  const factory UpdateDdayApiReqDto({
    required String ddayId,
    String? title,
    String? color,
    int? targetDatetime,
  }) = _UpdateDdayApiReqDto;

  factory UpdateDdayApiReqDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateDdayApiReqDtoFromJson(json);
}

class UpdateDdayApi {
  Dio dio;

  UpdateDdayApi({required this.dio});

  Future<void> execute(UpdateDdayApiReqDto dto) async {
    await dio.patch('/dday/${dto.ddayId}', data: dto.toJson());
  }
}

@riverpod
UpdateDdayApi updateDdayApi(Ref ref) {
  final dio = ref.watch(dioProvider);

  return UpdateDdayApi(dio: dio);
}
