import 'dart:async';

import 'package:StudyDuck/core/widgets/admob_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../core/utils/get_formatted_time.dart';
import '../../../core/utils/selection_haptic.dart';
import '../../providers/suduck_timer/suduck_timer_provider_2_0.dart';
import '../../viewmodels/timer/timer_bg_color_provider.dart';

class SuduckTimerFocusModeWidget extends ConsumerStatefulWidget {
  const SuduckTimerFocusModeWidget({super.key});

  @override
  ConsumerState<SuduckTimerFocusModeWidget> createState() =>
      _SuduckTimerFocusModeWidgetState();
}

class _SuduckTimerFocusModeWidgetState
    extends ConsumerState<SuduckTimerFocusModeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _colorController;
  late Animation<Color?> _colorAnimation;

  StreamSubscription? _accelerometerSubscription;
  bool _isAlertVisible = false;
  Timer? _alertTimer;
  DateTime? _lastMovementTime;
  Color? _lastColor;
  Color? _currentBgColor;

  // 설정값
  DateTime? _lastDialogTime; // 마지막 대화창 시간
  double _previousX = 0, _previousY = 0, _previousZ = 0; // 가속도 값 초기화
  final double _movementThreshold = 2.2; // 움직임 감지 임계값
  final Duration _dialogCooldown = Duration(seconds: 60); // 다이얼로그후 설정값이 지나야 재감지

  final int _inactiveThreshold = 6; // 설정시간동안 움직이지 않으면 다이얼로그 닫음

  // 추가할 변수들
  bool _isInitialized = false;
  final _initializationDelay = const Duration(seconds: 180); //감지 초기화 지연시간

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();

    // 지연후 센서 시작
    Future.delayed(_initializationDelay, () {
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _startAccelerometer();
        });
      }
    });

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _colorController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _colorAnimation = ColorTween(
      begin: ref.read(timerBgColorProvider),
      end: ref.read(timerBgColorProvider),
    ).animate(_colorController);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _lastColor = ref.read(timerBgColorProvider);
    _currentBgColor = ref.read(timerBgColorProvider);
  }

  void _checkNoMovement() {
    if (_lastMovementTime != null &&
        DateTime.now().difference(_lastMovementTime!) >
            Duration(seconds: _inactiveThreshold)) {
      if (mounted && _isAlertVisible) {
        Navigator.of(context).pop();
        setState(() {
          _isAlertVisible = false;
        });
      }
    }
  }

  void updateAnimation(Color newColor) {
    if (!mounted) return;

    setState(() {
      _colorAnimation = ColorTween(
        begin: _colorAnimation.value ?? _currentBgColor,
        end: newColor,
      ).animate(_colorController);
      _lastColor = newColor;
      _currentBgColor = newColor;
      _colorController.forward(from: 0);
    });
  }

  @override
  void dispose() {
    _isInitialized = false;
    _stopAccelerometer();
    _alertTimer?.cancel();

    if (mounted) {
      WakelockPlus.disable();
    }

    if (_colorController.isAnimating) {
      _colorController.stop();
    }
    _colorController.dispose();

    if (mounted) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    super.dispose();
  }

  void _startAccelerometer() {
    _accelerometerSubscription ??=
        accelerometerEventStream().listen((AccelerometerEvent event) {
      if (!mounted || !_isInitialized || _isAlertVisible) return;

      // 움직임 계산
      double deltaX = (_previousX - event.x).abs();
      double deltaY = (_previousY - event.y).abs();
      double deltaZ = (_previousZ - event.z).abs();

      // 첫 번째 값 설정
      if (_previousX == 0 && _previousY == 0 && _previousZ == 0) {
        _previousX = event.x;
        _previousY = event.y;
        _previousZ = event.z;
        return;
      }

      _previousX = event.x;
      _previousY = event.y;
      _previousZ = event.z;

      bool isMoving = (deltaX > _movementThreshold ||
          deltaY > _movementThreshold ||
          deltaZ > _movementThreshold);

      DateTime now = DateTime.now();
      bool isCooldownOver = _lastDialogTime == null ||
          now.difference(_lastDialogTime!) > _dialogCooldown;

      if (isMoving && isCooldownOver) {
        _lastDialogTime = now;
        if (!_isAlertVisible) {
          _showConcentrationAlert();
        }
      }
    });
  }

  void _stopAccelerometer() {
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;
  }

  void _showConcentrationAlert() async {
    if (!mounted || _isAlertVisible) return;

    setState(() {
      _isAlertVisible = true;
    });
    await SelectionHaptic.warning();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        _alertTimer?.cancel();
        _alertTimer = Timer(Duration(seconds: _inactiveThreshold), () {
          if (mounted && _isAlertVisible) {
            Navigator.of(context).pop();
            setState(() {
              _isAlertVisible = false;
            });
          }
        });

        return AlertDialog(
          title: Center(child: Text("Dialog.Focus!").tr()),
          content: Column(
            children: [
              Text("Dialog.YouarestudyingPutyourphonedownandfocus").tr(),
              Gap(20),
              Container(
                width: 150.w, // 원하는 너비
                height: 250.h, // 원하는 높이
                child: AdMobWidget.showBannerAd(280), // 배너 광고의 높이와 일치
              ),
            ],
          ),
        );
      },
    ).then((_) {
      if (mounted) {
        setState(() {
          _isAlertVisible = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final suduckTimer = ref.watch(suDuckTimerProvider);
    final suduckTimerNotifier = ref.read(suDuckTimerProvider.notifier);
    final bgColor = ref.watch(timerBgColorProvider);

    _checkNoMovement();
    updateAnimation(bgColor);

    final bool isRunning = suduckTimer.isRunning;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _colorAnimation.value,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _colorAnimation,
          builder: (context, child) {
            return Row(
              children: [
                Expanded(
                  child: Container(
                    color: _colorAnimation.value,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    color: _colorAnimation.value,
                    child: TimerCenter(
                      colorAnimation: _colorAnimation,
                      suduckTimer: suduckTimer,
                      isRunning: isRunning,
                      suduckTimerNotifier: suduckTimerNotifier,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: _colorAnimation.value,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class TimerCenter extends StatelessWidget {
  const TimerCenter({
    super.key,
    required Animation<Color?> colorAnimation,
    required this.suduckTimer,
    required this.isRunning,
    required this.suduckTimerNotifier,
  }) : _colorAnimation = colorAnimation;

  final Animation<Color?> _colorAnimation;
  final TimerState suduckTimer;
  final bool isRunning;
  final SuDuckTimer suduckTimerNotifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            width: double.infinity,
            color: _colorAnimation.value,
            child: Center(
              child: Text(
                suduckTimer.currSubject == null
                    ? tr("Timer.SelfStudy")
                    : suduckTimer.currSubject!.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Container(
            width: double.infinity,
            color: _colorAnimation.value,
            child: Center(
              child: Text(
                getFormatTime(suduckTimer.elapsedTime),
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            width: double.maxFinite,
            color: _colorAnimation.value,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (isRunning || suduckTimer.elapsedTime > 0)
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      suduckTimerNotifier.resetTimer();
                    },
                    child: Container(
                      width: 32.w,
                      height: 88.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border(
                          bottom: BorderSide(
                            width: 8.h,
                            color: const Color(0xffEBEBEB),
                          ),
                        ),
                      ),
                      child: Icon(
                        Icons.delete_rounded,
                        size: 12.w,
                        color: _colorAnimation.value,
                      ),
                    ),
                  ),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      if (!isRunning) {
                        suduckTimer.currSubject == null
                            ? suduckTimerNotifier.startTimer()
                            : suduckTimerNotifier.startTimer(
                                subject: suduckTimer.currSubject!);
                      } else {
                        suduckTimerNotifier.stopTimer();
                      }
                    },
                    child: Container(
                      width: 64.w,
                      height: 88.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border(
                          bottom: BorderSide(
                            width: 8.h,
                            color: const Color(0xffEBEBEB),
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          (!isRunning) ? tr("Timer.Start") : tr("Timer.Pause"),
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w500,
                            color: _colorAnimation.value,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (isRunning || suduckTimer.elapsedTime > 0)
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      suduckTimerNotifier.saveTimer();
                    },
                    child: Container(
                      width: 32.w,
                      height: 88.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border(
                          bottom: BorderSide(
                            width: 8.h,
                            color: const Color(0xffEBEBEB),
                          ),
                        ),
                      ),
                      child: Icon(
                        Icons.save_rounded,
                        size: 12.w,
                        color: _colorAnimation.value,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Spacer(flex: 2)
      ],
    );
  }
}
