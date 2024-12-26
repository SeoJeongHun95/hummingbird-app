import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../providers/dio_providers/public_dio_provider.dart';

part 'google_login_api.freezed.dart';
part 'google_login_api.g.dart';

@freezed
class GoogleLoginApiRequest with _$GoogleLoginApiRequest {
  const factory GoogleLoginApiRequest({
    required String googleId,
    required String email,
    String? nickname,
    String? thumbnailUrl,
  }) = _GoogleLoginApiRequest;

  factory GoogleLoginApiRequest.fromJson(Map<String, dynamic> json) =>
      _$GoogleLoginApiRequestFromJson(json);
}

@freezed
class GoogleLoginApiResponse with _$GoogleLoginApiResponse {
  const factory GoogleLoginApiResponse({
    required String accessToken,
    required String refreshToken,
    required int tokenExpiresAtInSeconds,
  }) = _GoogleLoginApiResponse;

  factory GoogleLoginApiResponse.fromJson(Map<String, dynamic> json) =>
      _$GoogleLoginApiResponseFromJson(json);
}

class GoogleLoginApi {
  Dio dio;

  GoogleLoginApi({required this.dio});

  Future<GoogleLoginApiResponse> execute(GoogleLoginApiRequest dto) async {
    final response = await dio.post('/auth/google', data: dto.toJson());
    return GoogleLoginApiResponse.fromJson(response.data);
  }
}

@riverpod
GoogleLoginApi googleLoginApi(Ref ref) {
  final dio = ref.read(publicDioProvider);

  return GoogleLoginApi(dio: dio);
}
