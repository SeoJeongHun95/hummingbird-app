import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/get_formatted_time.dart';
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

  @override
  void initState() {
    super.initState();
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

  void updateAnimation(Color newColor) {
    _colorAnimation = ColorTween(
      begin: _colorAnimation.value,
      end: newColor,
    ).animate(_colorController);
    _colorController.forward(from: 0);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _colorController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final suduckTimer = ref.watch(suDuckTimerProvider);
    final suduckTimerNotifier = ref.read(suDuckTimerProvider.notifier);
    final bgColor = ref.watch(timerBgColorProvider);

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
                //FocusScreen Left
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
                //FocusScreen Right
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
                    ? "자율 학습"
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
                          (!isRunning) ? "START" : "PAUSE",
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
