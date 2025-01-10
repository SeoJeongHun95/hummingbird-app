import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/env.dart';

part 'public_dio_provider.g.dart';

@Riverpod(keepAlive: true)
Dio publicDio(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.serverBaseUrl,
    ),
  );

  dio.interceptors.add(InterceptorsWrapper(onError: (error, handler) async {
    //   TODO: add global error handling
    print(error);
  }));

  return dio;
}
