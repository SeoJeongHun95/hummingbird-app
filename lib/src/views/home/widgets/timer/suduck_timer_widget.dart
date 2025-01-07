import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/enum/mxnRate.dart';
import '../../../../../core/widgets/mxnContainer.dart';
import '../../../../providers/suduck_timer/suduck_timer_provider.dart';

final Color timerMainColor = Color(0xffba4849);

class SuDuckTimerWidget extends ConsumerStatefulWidget {
  const SuDuckTimerWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SuDuckTimerWidgetState();
}

class _SuDuckTimerWidgetState extends ConsumerState<SuDuckTimerWidget> {
  bool isPushed = false;

  String _formatTime(int seconds) {
    final int hours = seconds ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    final int secs = seconds % 60;

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final suduckTimer = ref.watch(suDuckTimerProvider);
    final sudeckTimerNotifier = ref.read(suDuckTimerProvider.notifier);

    return MxNcontainer(
      MxN_rate: MxNRate.FOURBYTHREE,
      MxN_child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 140.h,
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
          Container(
            color: timerMainColor,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      !isPushed
                          ? sudeckTimerNotifier.startTimer()
                          : sudeckTimerNotifier.stopTimer();
                      setState(() {
                        isPushed = !isPushed;
                      });
                    },
                    child: Container(
                      width: 120.w,
                      height: 44.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border(
                          bottom:
                              BorderSide(width: 4.h, color: Color(0xffEBEBEB)),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          (!isPushed) ? "START" : "STOP",
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
                if (!isPushed && suduckTimer.elapsedTime > 0)
                  Positioned(
                    right: 64,
                    top: 8,
                    child: GestureDetector(
                      onTap: sudeckTimerNotifier.resetTimer,
                      child: Icon(
                        Icons.restore,
                        size: 32.w,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Container(color: timerMainColor),
          ),
        ],
      ),
    );
  }
}
