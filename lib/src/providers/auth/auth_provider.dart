import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/utils.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  Stream<User?> build() {
    return FirebaseAuth.instance.authStateChanges();
  }

  User? get user => state.asData?.value;

  bool get isLoggedIn => user != null;

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      Exception("Google 로그인 실패: $e");
    }
  }

  Future<void> signInWithApple() async {
    try {
      final appleProvider = AppleAuthProvider();

      await FirebaseAuth.instance.signInWithProvider(appleProvider);
    } catch (e) {
      Exception("Apple 로그인 실패: $e");
    }
  }

  Future<void> signOut() async {
    var singOutFlag = await showConfirmDialog("", "로그아웃하시겠습니까?");

    if (singOutFlag) {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
    }
  }
}
