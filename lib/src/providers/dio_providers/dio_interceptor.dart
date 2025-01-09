import 'dart:async';

import 'package:dio/dio.dart';

import '../../models/token_model.dart';
import '../token_provider.dart';
import 'refresh_token_dio_client_provider.dart';

class DioInterceptor extends Interceptor {
  final RefreshTokenDioClient refreshTokenDioClient;
  final TokenProvider tokensProvider;
  final int refreshThresholdInMinutes;

  bool _isRefreshing = false;
  Completer<void>? _refreshCompleter;

  DioInterceptor({
    required this.refreshTokenDioClient,
    required this.tokensProvider,
    this.refreshThresholdInMinutes = 1,
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    //   TODO: Global error handling
  }

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final tokens = tokensProvider.getToken();
    final accessToken = tokens?.accessToken;
    final refreshToken = tokens?.refreshToken;
    final expiresAt = tokens?.expiresAt;

    if (accessToken == null || expiresAt == null || refreshToken == null) {
      return handler.reject(
        DioException(
          requestOptions: options,
          error: 'No access token found',
          type: DioExceptionType.cancel,
        ),
      );
    }

    final remainingTimeInSeconds =
        expiresAt - (DateTime.now().millisecondsSinceEpoch ~/ 1000);

    if (remainingTimeInSeconds <= refreshThresholdInMinutes * 60) {
      try {
        await _refreshToken(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
      } catch (e) {
        return handler.reject(
          DioException(
            requestOptions: options,
            error: 'Token refresh failed',
            type: DioExceptionType.badResponse,
          ),
        );
      }
    }

    options.headers['Authorization'] = tokensProvider.getToken()?.accessToken;

    return handler.next(options);
  }

  Future<void> _refreshToken({
    required String accessToken,
    required String refreshToken,
  }) async {
    if (_isRefreshing) {
      await _refreshCompleter?.future;
      return;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<void>();

    try {
      final res = await refreshTokenDioClient.dio.get('/auth/refresh');
      final newAccessToken = res.data['accessToken'];
      final newExpiresAt = res.data['tokenExpiresAtInSeconds'];

      tokensProvider.updateToken(TokenModel(
        accessToken: newAccessToken,
        refreshToken: refreshToken,
        expiresAt: newExpiresAt,
      ));
      _refreshCompleter?.complete();
    } catch (e) {
      _isRefreshing = false;
      _refreshCompleter = null;
      return;
    } finally {
      _isRefreshing = false;
      _refreshCompleter = null;
    }
  }
}
