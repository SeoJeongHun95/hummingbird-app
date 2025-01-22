import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/show_snack_bar.dart';
import '../../datasource/remote/auth/google_login_api.dart';
import '../../viewmodels/user_setting/user_setting_view_model.dart';
import 'auth_provider.dart';

part 'google_login_provider.g.dart';

@riverpod
class GoogleLogin extends _$GoogleLogin {
  @override
  GoogleLoginApi build() {
    return ref.watch(googleLoginApiProvider);
  }

  Future<void> googleLogin({
    required String googleId,
    required String email,
    String? displayName,
  }) async {
    final res = await state.execute(GoogleLoginApiRequest(
      googleId: googleId,
      email: email,
      nickname: displayName,
    ));

    ref.read(authProvider.notifier).login(
          accessToken: res.accessToken,
          refreshToken: res.refreshToken,
          expiresAt: res.expiresAt,
        );
    ref.read(userSettingViewModelProvider.notifier).addUserId(res.userId);
    showSnackBar(message: '로그인에 성공했습니다!');
  }
}
