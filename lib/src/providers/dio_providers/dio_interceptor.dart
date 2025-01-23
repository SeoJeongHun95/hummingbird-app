import 'dart:async';

import 'package:dio/dio.dart';

import '../../../core/utils/show_snack_bar.dart';
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
    //   TODO: Update Global error handling
    print(err);
    showSnackBar(message: err.message ?? '로그 확인 필요');
  }

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final tokens = tokensProvider.getToken();
    final accessToken = tokens?.accessToken;
    final refreshToken = tokens?.refreshToken;
    final expiresAt = tokens?.expiresAt;
    final userId = tokens?.userId;

    if (accessToken == null ||
        expiresAt == null ||
        refreshToken == null ||
        userId == null) {
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
          userId: userId,
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
    required int userId,
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
      final newExpiresAt = res.data['expiresAt'];

      tokensProvider.updateToken(TokenModel(
        accessToken: newAccessToken,
        refreshToken: refreshToken,
        expiresAt: newExpiresAt,
        userId: userId,
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
