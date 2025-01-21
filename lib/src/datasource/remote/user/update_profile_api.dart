import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../providers/dio_providers/dio_provider.dart';

part 'update_profile_api.freezed.dart';
part 'update_profile_api.g.dart';

@freezed
class UpdateProfileApiReqDto with _$UpdateProfileApiReqDto {
  const factory UpdateProfileApiReqDto({
    String? nickname,
    String? birthDate,
    String? countryCode,
  }) = _UpdateProfileApiReqDto;

  factory UpdateProfileApiReqDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileApiReqDtoFromJson(json);
}

class UpdateProfileApi {
  Dio dio;

  UpdateProfileApi({required this.dio});

  Future<void> execute(UpdateProfileApiReqDto dto) async {
    await dio.patch('/users', data: dto.toJson());
  }
}

@riverpod
UpdateProfileApi updateProfileApi(Ref ref) {
  final dio = ref.watch(dioProvider);

  return UpdateProfileApi(dio: dio);
}
