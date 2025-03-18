import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth/auth_provider.dart';
import '../auth/apple_login_button.dart';
import '../auth/google_login_button.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _fadeAnimation;
  Animation<double>? _dropAnimation;
  Timer? _typeTimer;
  Timer? _progressTimer;
  final String message = tr("SplashScreen.message");
  String displayText = "";
  int currentCharIndex = 1;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller!,
      curve: const Interval(0.0, 0.5),
    ));

    _dropAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: -300.0, end: 20.0)
            .chain(CurveTween(curve: Curves.bounceOut)),
        weight: 60.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 20.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40.0,
      ),
    ]).animate(_controller!);

    _controller!.forward();

    _typeTimer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      setState(() {
        if (currentCharIndex < message.length) {
          displayText = message.substring(0, currentCharIndex + 1);
          currentCharIndex++;
        } else {
          timer.cancel();
        }
      });
    });

    _progressTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        if (_progress < 1.0) {
          _progress += 0.01;
        } else {
          timer.cancel();
          Future.delayed(const Duration(seconds: 1), () {
            context.pushReplacement('/');
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _typeTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final isLoggedIn = auth.asData?.value != null;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            FadeTransition(
              opacity: _fadeAnimation!,
              child: AnimatedBuilder(
                animation: _dropAnimation!,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _dropAnimation!.value),
                    child: ClipOval(
                      child: Image.asset(
                        'lib/core/imgs/images/StudyDuck.png',
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 300,
              child: LinearProgressIndicator(
                value: _progress,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.yellow),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              displayText,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontFamily: 'NanumPenScript',
              ),
            ),
            const Spacer(flex: 1),
            if (isLoggedIn == false) const GoogleLoginButton(),
            if (isLoggedIn == false) Gap(8.h),
            if (isLoggedIn == false && Platform.isIOS) const AppleLoginButton(),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
