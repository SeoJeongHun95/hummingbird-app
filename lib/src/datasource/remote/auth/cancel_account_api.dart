import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hummingbird/src/providers/dio_providers/dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cancel_account_api.g.dart';

class CancelAccountApi {
  Dio dio;

  CancelAccountApi({required this.dio});

  Future<void> execute() async {
    await dio.delete('/auth');
  }
}

@riverpod
CancelAccountApi cancelAccountApi(Ref ref) {
  final dio = ref.read(dioProvider);

  return CancelAccountApi(dio: dio);
}
