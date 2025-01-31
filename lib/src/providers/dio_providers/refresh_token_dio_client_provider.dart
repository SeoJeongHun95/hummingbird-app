import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/env.dart';
import '../token_provider.dart';

part 'refresh_token_dio_client_provider.g.dart';

class RefreshTokenDioClient {
  final Dio dio;
  final Ref ref;

  RefreshTokenDioClient({required this.dio, required this.ref}) {
    dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException error, ErrorInterceptorHandler handler) async {
        if (error.response?.statusCode == 401 ||
            error.response?.statusCode == 403) {
          _handleLogout();
        }

        return handler.next(error);
      },
    ));
  }

  void _handleLogout() {
    ref.read(tokenProvider).deleteToken();

    // Navigator.of(navigatorKey.currentContext!).pushNamedAndRemoveUntil(
    //   urls.root.login,
    //   (route) => false,
    // );
  }
}

@riverpod
RefreshTokenDioClient refreshTokenDioClient(Ref ref) {
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

  return RefreshTokenDioClient(dio: dio, ref: ref);
}
