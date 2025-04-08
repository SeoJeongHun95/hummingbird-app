import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  Color? _lastColor;
  Color? _currentBgColor;
  String? _temporaryMessage;
  Timer? _resetTimer;
  Timer? _hapticTimer;
  bool _canProcessMovement = true;

  // 설정값
  DateTime? _lastDialogTime; // 마지막 대화창 시간
  double _previousX = 0, _previousY = 0, _previousZ = 0; // 가속도 값 초기화
  final double _movementThreshold = 1.5; // 핸드폰을 들어올리는 동작 감지를 위한 임계값
  final Duration _dialogCooldown = Duration(seconds: 20); // 다이얼로그후 설정값이 지나야 재감지

  final int _inactiveThreshold = 3; // 설정시간동안 움직이지 않으면 다이얼로그 닫음

  // 추가할 변수들
  bool _isInitialized = false;
  final _initializationDelay = const Duration(seconds: 15); //감지 초기화 지연시간
  int _consecutiveMovements = 0; // 연속된 움직임 감지 횟수
  final int _requiredConsecutiveMovements = 3; // 필요한 연속 움직임 횟수
  DateTime? _lastMovementDetectionTime;
  final Duration _movementResetDuration =
      Duration(milliseconds: 800); // 움직임 초기화 시간
  bool _isProcessingMovement = false;

  void _resetAllStates() {
    if (mounted) {
      _stopHapticFeedback();
      setState(() {
        _isAlertVisible = false;
        _temporaryMessage = null;
        _isProcessingMovement = false;
        _consecutiveMovements = 0;
        _previousX = 0;
        _previousY = 0;
        _previousZ = 0;
        _canProcessMovement = true;
      });
    }
  }

  void _showConcentrationAlert() async {
    if (!mounted) return;

    try {
      if (!mounted || _isAlertVisible) return;

      _resetTimer?.cancel();
      _hapticTimer?.cancel();

      setState(() {
        _isAlertVisible = true;
        _temporaryMessage = tr("Dialog.YouarestudyingPutyourphonedownandfocus");
        _canProcessMovement = false;
      });

      // 햅틱 피드백 시작
      _startHapticFeedback();

      _resetTimer = Timer(Duration(seconds: _inactiveThreshold), () {
        _stopHapticFeedback();
        _resetAllStates();
      });
    } catch (e) {
      debugPrint('Error in showConcentrationAlert: $e');
      _stopHapticFeedback();
      _resetAllStates();
    }
  }

  void _startHapticFeedback() {
    // 초기 햅틱
    HapticFeedback.mediumImpact();

    // 500ms 간격으로 햅틱 피드백 반복
    _hapticTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (mounted && _isAlertVisible) {
        HapticFeedback.mediumImpact();
      } else {
        _stopHapticFeedback();
      }
    });
  }

  void _stopHapticFeedback() {
    _hapticTimer?.cancel();
    _hapticTimer = null;
  }

  @override
  void initState() {
    super.initState();
    _initWakelock();

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
    if (_isAlertVisible) {
      _resetTimer = Timer(Duration(seconds: _inactiveThreshold), () {
        _resetAllStates();
      });
    }
  }

  void _checkNoMovement() {
    // This method is now empty as the logic has been updated
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
    _resetTimer?.cancel();
    _resetTimer = null;
    _stopHapticFeedback();
    _isInitialized = false;
    _stopAccelerometer();
    _canProcessMovement = false;

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
    _stopAccelerometer();
    _accelerometerSubscription ??=
        accelerometerEventStream(samplingPeriod: Duration(milliseconds: 2500))
            .listen((AccelerometerEvent event) {
      if (!mounted ||
          !_isInitialized ||
          _isAlertVisible ||
          !_canProcessMovement) return;

      // 움직임 계산
      try {
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

        DateTime now = DateTime.now();
        bool isMovementExpired = _lastMovementDetectionTime == null ||
            now.difference(_lastMovementDetectionTime!) >
                _movementResetDuration;

        if (isMovementExpired) {
          _consecutiveMovements = 0;
        }

        _previousX = event.x;
        _previousY = event.y;
        _previousZ = event.z;

        // 수직 방향(Z축) 변화에 더 큰 가중치 부여
        bool isSignificantVerticalMovement = deltaZ > _movementThreshold * 1.2;
        bool isGeneralMovement = (deltaX > _movementThreshold ||
            deltaY > _movementThreshold ||
            deltaZ > _movementThreshold);

        bool isMoving = isSignificantVerticalMovement || isGeneralMovement;

        if (isMoving) {
          _consecutiveMovements++;
          _lastMovementDetectionTime = now;
        }

        bool isCooldownOver = _lastDialogTime == null ||
            now.difference(_lastDialogTime!) > _dialogCooldown;

        if (_consecutiveMovements >= _requiredConsecutiveMovements &&
            isCooldownOver &&
            _canProcessMovement) {
          _consecutiveMovements = 0;
          _lastDialogTime = now;
          _showConcentrationAlert();
        }
      } catch (e) {
        debugPrint('Error processing accelerometer event: $e');
        _resetAllStates();
      }
    });
  }

  void _stopAccelerometer() {
    if (_accelerometerSubscription != null) {
      _accelerometerSubscription?.cancel();
      _accelerometerSubscription = null;
    }
  }

  @override
  void didUpdateWidget(SuduckTimerFocusModeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // This method is now empty as the logic has been updated
  }

  @override
  Widget build(BuildContext context) {
    final suduckTimer = ref.watch(suDuckTimerProvider);
    final suduckTimerNotifier = ref.read(suDuckTimerProvider.notifier);
    final bgColor = ref.watch(timerBgColorProvider);

    _checkNoMovement();
    updateAnimation(bgColor);

    final bool isRunning = suduckTimer.isRunning;
    Color textColor = Colors.white;
    if (_colorAnimation.value != null) {
      if (_temporaryMessage != null) {
        textColor = _getReadableTextColor(_colorAnimation.value!);
      } else {
        textColor = Colors.white;
      }
    }

    if (_isAlertVisible && _resetTimer == null) {
      _resetTimer = Timer(Duration(seconds: _inactiveThreshold), () {
        _resetAllStates();
      });
    }

    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _colorAnimation,
          builder: (context, child) {
            return Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          color: _colorAnimation.value,
                          child: Row(
                            children: [
                              Spacer(
                                flex: 2,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                      size: 14.sp,
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(
                                flex: 3,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Container(
                          color: _colorAnimation.value,
                        ),
                      ),
                    ],
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
                      temporaryMessage: _temporaryMessage,
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

  Future<void> _initWakelock() async {
    try {
      await WakelockPlus.enable();
    } catch (e) {
      debugPrint('Wakelock enable error: $e');
    }
  }

  Color _getReadableTextColor(Color backgroundColor) {
    HSLColor hsl = HSLColor.fromColor(backgroundColor);

    if (hsl.lightness > 0.7) {
      return hsl.withLightness(0.2).toColor();
    } else if (hsl.lightness < 0.3) {
      return hsl.withLightness(0.9).toColor();
    } else {
      return hsl.withLightness(hsl.lightness < 0.5 ? 0.9 : 0.1).toColor();
    }
  }
}

class TimerCenter extends StatelessWidget {
  const TimerCenter({
    super.key,
    required Animation<Color?> colorAnimation,
    required this.suduckTimer,
    required this.isRunning,
    required this.suduckTimerNotifier,
    required this.temporaryMessage,
  }) : _colorAnimation = colorAnimation;

  final Animation<Color?> _colorAnimation;
  final TimerState suduckTimer;
  final bool isRunning;
  final SuDuckTimer suduckTimerNotifier;
  final String? temporaryMessage;

  @override
  Widget build(BuildContext context) {
    Color textColor = Colors.white;
    if (_colorAnimation.value != null) {
      if (temporaryMessage != null) {
        textColor = _getReadableTextColor(_colorAnimation.value!);
      } else {
        textColor = Colors.white;
      }
    }

    return Column(
      children: [
        Spacer(
          flex: 2,
        ),
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
              child: temporaryMessage != null
                  ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(
                        temporaryMessage!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                          color: _getReadableTextColor(_colorAnimation.value!),
                        ),
                      ),
                    )
                  : Text(
                      getFormatTime(suduckTimer.elapsedTime),
                      style: TextStyle(
                        fontSize: 46.sp,
                        fontWeight: FontWeight.w600,
                        color: textColor,
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
                      SelectionHaptic.vibrate();
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
      ],
    );
  }

  Color _getReadableTextColor(Color backgroundColor) {
    HSLColor hsl = HSLColor.fromColor(backgroundColor);

    if (hsl.lightness > 0.7) {
      return hsl.withLightness(0.2).toColor();
    } else if (hsl.lightness < 0.3) {
      return hsl.withLightness(0.9).toColor();
    } else {
      return hsl.withLightness(hsl.lightness < 0.5 ? 0.9 : 0.1).toColor();
    }
  }
}
