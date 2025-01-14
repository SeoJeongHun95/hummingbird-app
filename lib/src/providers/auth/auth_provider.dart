import 'package:hummingbird/core/utils/show_snack_bar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/show_confirm_dialog.dart';
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

  void logout() async {
    final confirm =
        await showConfirmDialog('로그아웃하시겠어요?', '로그아웃 후 로그인 화면으로 돌아갑니다.');

    if (!confirm) {
      return;
    }

    ref.read(tokenProvider).deleteToken();
    state = false;
    showSnackBar(message: '로그아웃되었습니다.');
  }
}
