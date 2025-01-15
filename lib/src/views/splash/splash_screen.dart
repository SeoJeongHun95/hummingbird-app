import 'package:flutter/material.dart';
<<<<<<< Updated upstream
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/delay.dart';
import '../../providers/auth/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    delay(() async {
      final isLoggedIn = ref.watch(authProvider);

      if (!isLoggedIn) {
        context.pushReplacement('/login');
      } else {
        context.pushReplacement('/');
      }
    }, seconds: 1);
=======
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _fadeAnimation;
  Animation<double>? _dropAnimation;
  final String message = "오늘도 최선을 다해서 Study Duck과 함께...";
  String displayText = "";
  int currentCharIndex = 1;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();

    // 애니메이션 컨트롤러 설정
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // 페이드 애니메이션
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller!,
      curve: const Interval(0.0, 0.5),
    ));

    // 드롭 & 바운스 애니메이션
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

    // 글자 타이핑 애니메이션
    Timer.periodic(const Duration(milliseconds: 80), (timer) {
      setState(() {
        if (currentCharIndex < message.length) {
          displayText = message.substring(0, currentCharIndex + 1);
          currentCharIndex++;
        } else {
          timer.cancel();
        }
      });
    });

    // 프로그레스 바 애니메이션
    Timer.periodic(const Duration(milliseconds: 30), (timer) {
      setState(() {
        if (_progress < 1.0) {
          _progress += 0.01;
        } else {
          timer.cancel();
          Future.delayed(const Duration(seconds: 1), () {
            //todo: 홈 화면으로 이동
            Navigator.pop(context);
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
>>>>>>> Stashed changes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< Updated upstream
      body: SafeArea(
        child: Center(
          child: Text('Hummingbird Logo'),
=======
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            const SizedBox(height: 20),
          ],
>>>>>>> Stashed changes
        ),
      ),
    );
  }
}
