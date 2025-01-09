import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hummingbird/src/providers/dio_providers/dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_dday_api.g.dart';

class DeleteDdayApi {
  Dio dio;

  DeleteDdayApi({required this.dio});

  Future<void> execute({required String ddayId}) async {
    await dio.delete('/dday/$ddayId}');
  }
}

@riverpod
DeleteDdayApi deleteDdayApi(Ref ref) {
  final dio = ref.watch(dioProvider);

  return DeleteDdayApi(dio: dio);
}
