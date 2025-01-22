import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../providers/dio_providers/dio_provider.dart';

part 'get_profile_api.freezed.dart';
part 'get_profile_api.g.dart';

@freezed
class GetProfileApiResDto with _$GetProfileApiResDto {
  const factory GetProfileApiResDto({
    String? nickname,
    String? birthDate,
    String? countryCode,
  }) = _GetProfileApiResDto;

  factory GetProfileApiResDto.fromJson(Map<String, dynamic> json) =>
      _$GetProfileApiResDtoFromJson(json);
}

class GetProfileApi {
  Dio dio;

  GetProfileApi({required this.dio});

  Future<GetProfileApiResDto> execute() async {
    final response = await dio.get('/users');

    return GetProfileApiResDto.fromJson(response.data);
  }
}

@riverpod
GetProfileApi getProfileApi(Ref ref) {
  final dio = ref.watch(dioProvider);

  return GetProfileApi(dio: dio);
}
