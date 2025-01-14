import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/enum/mxnRate.dart';
import '../../../../../core/widgets/mxnContainer.dart';
import '../../../../providers/suduck_timer/suduck_timer_provider.dart';

//TODO 타이머 복구 할지 말지 다이어로그로 고르게하기

class SuDuckTimerWidget extends ConsumerStatefulWidget {
  const SuDuckTimerWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SuDuckTimerWidgetState();
}

class _SuDuckTimerWidgetState extends ConsumerState<SuDuckTimerWidget> {
  String _formatTime(int seconds) {
    final int hours = seconds ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    final int secs = seconds % 60;

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${secs.toString().padLeft(2, '0')}';
  }

  final Color timerMainColor = Color(0xffba4849);

  @override
  Widget build(BuildContext context) {
    final suduckTimer = ref.watch(suDuckTimerProvider);
    final sudeckTimerNotifier = ref.read(suDuckTimerProvider.notifier);

    final bool isRunning = suduckTimer.isRunning;

    return MxNcontainer(
      MxN_rate: MxNRate.FOURBYTHREE,
      MxN_child: Column(
        children: [
          Expanded(child: Container(color: timerMainColor)),
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              color: timerMainColor,
              child: Center(
                child: Center(
                  child: Text(
                    "과목입니다",
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              color: timerMainColor,
              child: Center(
                child: Text(
                  _formatTime(suduckTimer.elapsedTime),
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
              color: timerMainColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (isRunning || suduckTimer.elapsedTime > 0)
                    GestureDetector(
                      onTap: sudeckTimerNotifier.resetTimer,
                      child: Container(
                        width: 48.w,
                        height: 44.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border(
                            bottom: BorderSide(
                              width: 4.h,
                              color: Color(0xffEBEBEB),
                            ),
                          ),
                        ),
                        child: Icon(
                          Icons.delete_rounded,
                          size: 24.w,
                          color: timerMainColor,
                        ),
                      ),
                    ),
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        if (!isRunning) {
                          sudeckTimerNotifier.startTimer();
                        } else {
                          sudeckTimerNotifier.stopTimer();
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
                              color: Color(0xffEBEBEB),
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            (!isRunning) ? "START" : "PAUSE",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              color: timerMainColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (isRunning || suduckTimer.elapsedTime > 0)
                    GestureDetector(
                      onTap: sudeckTimerNotifier.saveTimer,
                      child: Container(
                        width: 48.w,
                        height: 44.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border(
                            bottom: BorderSide(
                              width: 4.h,
                              color: Color(0xffEBEBEB),
                            ),
                          ),
                        ),
                        child: Icon(
                          Icons.save_rounded,
                          size: 24.w,
                          color: timerMainColor,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Expanded(child: Container(color: timerMainColor)),
        ],
      ),
    );
  }
}
