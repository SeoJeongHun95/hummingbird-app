import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/env.dart';
import '../token_provider.dart';
import 'dio_interceptor.dart';
import 'refresh_token_dio_client_provider.dart';

part 'dio_provider.g.dart';

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final refreshTokenDioClient = ref.watch(refreshTokenDioClientProvider);
  final tokensHandler = ref.watch(tokenProvider);
  final tokens = tokensHandler.getToken();
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.serverBaseUrl,
      headers: {
        'Authorization': tokens?.accessToken,
        'RefreshToken': tokens?.refreshToken,
      },
    ),
  );

  dio.interceptors.add(DioInterceptor(
      dio: dio,
      refreshTokenDioClient: refreshTokenDioClient,
      tokensProvider: tokensHandler));

  return dio;
}
