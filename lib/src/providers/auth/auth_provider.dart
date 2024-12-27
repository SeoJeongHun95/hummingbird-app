import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/token_model.dart';
import '../token_provider.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  bool build() {
    final token = ref.watch(tokenProvider);
    final tokenModel = token.getToken();

    if (tokenModel == null ||
        tokenModel.accessToken == null ||
        tokenModel.refreshToken == null) {
      return false;
    }

    return true;
  }

  void login({
    required String accessToken,
    required String refreshToken,
    required int expiresAt,
  }) {
    ref.read(tokenProvider).updateToken(TokenModel(
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresAt: expiresAt));
    state = true;
  }

  void logout() {
    ref.read(tokenProvider).deleteToken();
    state = false;
  }
}
