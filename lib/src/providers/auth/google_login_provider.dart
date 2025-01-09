import 'package:hummingbird/src/providers/auth/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../datasource/remote/auth/google_login_api.dart';

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
  }
}
