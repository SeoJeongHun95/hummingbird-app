import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/enum/mxnRate.dart';
import '../../../../../core/utils/get_formatted_time.dart';
import '../../../../../core/widgets/mxnContainer.dart';
import '../../../../providers/suduck_timer/suduck_timer_provider.dart';
import '../../../../viewmodels/timer/timer_bg_color_provider.dart';

class SuDuckTimerWidget extends ConsumerStatefulWidget {
  const SuDuckTimerWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SuDuckTimerWidgetState();
}

class _SuDuckTimerWidgetState extends ConsumerState<SuDuckTimerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _colorController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    final suduckTimer = ref.watch(suDuckTimerProvider);
    final suduckTimerNotifier = ref.read(suDuckTimerProvider.notifier);
    final bgColor = ref.watch(timerBgColorProvider);

    updateAnimation(bgColor);

    final bool isRunning = suduckTimer.isRunning;

    return MxNcontainer(
      MxN_rate: MxNRate.FOURBYTHREE,
      MxN_child: AnimatedBuilder(
        animation: _colorAnimation,
        builder: (context, child) {
          return Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  color: _colorAnimation.value,
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  color: _colorAnimation.value,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: suduckTimer.currSubject != null && !isRunning
                            ? IconButton(
                                onPressed: () =>
                                    suduckTimerNotifier.resetSubject(),
                                icon: Icon(Icons.delete_forever_rounded),
                                color: Colors.white,
                              )
                            : Container(),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            suduckTimer.currSubject == null
                                ? "미분류"
                                : suduckTimer.currSubject!.title,
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontFeatures: [FontFeature.tabularFigures()],
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  width: double.infinity,
                  color: _colorAnimation.value,
                  child: Center(
                    child: Text(
                      getFormatTime(suduckTimer.elapsedTime),
                      style: TextStyle(
                        fontSize: 52.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  width: double.maxFinite,
                  color: _colorAnimation.value,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (isRunning || suduckTimer.elapsedTime > 0)
                        GestureDetector(
                          onTap: suduckTimerNotifier.resetTimer,
                          child: Container(
                            width: 48.w,
                            height: 44.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border(
                                bottom: BorderSide(
                                  width: 4.h,
                                  color: const Color(0xffEBEBEB),
                                ),
                              ),
                            ),
                            child: Icon(
                              Icons.delete_rounded,
                              size: 24.w,
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
                            width: 120.w,
                            height: 44.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border(
                                bottom: BorderSide(
                                  width: 4.h,
                                  color: const Color(0xffEBEBEB),
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                (!isRunning) ? "START" : "PAUSE",
                                style: TextStyle(
                                  fontSize: 18.sp,
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
                          onTap: suduckTimerNotifier.saveTimer,
                          child: Container(
                            width: 48.w,
                            height: 44.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border(
                                bottom: BorderSide(
                                  width: 4.h,
                                  color: const Color(0xffEBEBEB),
                                ),
                              ),
                            ),
                            child: Icon(
                              Icons.save_rounded,
                              size: 24.w,
                              color: _colorAnimation.value,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(child: Container(color: _colorAnimation.value)),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _colorController.dispose();
    super.dispose();
  }
}
