import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hummingbird/core/utils/is_android.dart';
import 'package:hummingbird/src/models/env.dart';

import '../../providers/auth/google_login_provider.dart';

class GoogleLoginButton extends ConsumerWidget {
  final _googleSignIn =
      isAndroid() ? GoogleSignIn() : GoogleSignIn(clientId: Env.googleClientId);

  GoogleLoginButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OutlinedButton(
      onPressed: () async {
        try {
          final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

          if (googleUser == null) {
            return;
          }

          await ref.read(googleLoginProvider.notifier).googleLogin(
                googleId: googleUser.id,
                email: googleUser.email,
                displayName: googleUser.displayName,
              );
        } catch (err) {
          print(err);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Gap(
            8.0,
          ),
          const Text(
            'Sign in with Google',
          ),
        ],
      ),
    );
  }
}
