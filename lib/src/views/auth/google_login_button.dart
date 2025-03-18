import 'package:StudyDuck/src/providers/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GoogleLoginButton extends ConsumerWidget {
  const GoogleLoginButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: () async =>
          await ref.read(authProvider.notifier).signInWithGoogle(),
      label: Text(
        "Sign in with Google",
        style: TextStyle(
          color: Colors.black,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      icon: Image.asset(
        "lib/core/imgs/icons/google_logo.png",
        height: 40.h,
        width: 40.h,
      ),
      style: ElevatedButton.styleFrom(
        fixedSize: Size.fromWidth(240.w),
        backgroundColor: Color(0xffF2F2F2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.black, width: 1),
        ),
      ),
    );
  }
}
