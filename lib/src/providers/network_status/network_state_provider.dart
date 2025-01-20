import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_state_provider.g.dart';

@riverpod
class NetworkState extends _$NetworkState {
  late final StreamSubscription<List<ConnectivityResult>>
      connectivitySubscription;
  late final Connectivity connectivity;

  @override
  Future<bool> build() async {
    connectivity = Connectivity();
    List<ConnectivityResult> result;
    try {
      result = await connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      throw Exception("연결 상태를 확인할 수 없습니다: $e");
    }
    updateConnectionStatus(result);

    connectivitySubscription =
        connectivity.onConnectivityChanged.listen(updateConnectionStatus);

    ref.onDispose(connectivitySubscription.cancel);

    return await future;
  }

  void updateConnectionStatus(List<ConnectivityResult> result) =>
      state = AsyncData(result[result.length - 1] != ConnectivityResult.none);
}
