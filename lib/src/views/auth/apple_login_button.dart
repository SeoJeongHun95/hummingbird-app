import 'package:StudyDuck/src/providers/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppleLoginButton extends ConsumerWidget {
  const AppleLoginButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: () async =>
          await ref.read(authProvider.notifier).signInWithApple(),
      label: Text(
        " Sign in with Apple ",
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      icon: Image.asset(
        "lib/core/imgs/icons/apple_logo_black.png",
        height: 40.h,
        width: 40.h,
      ),
      style: ElevatedButton.styleFrom(
        fixedSize: Size.fromWidth(240.w),
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.black, width: 1),
        ),
      ),
    );
  }
}
