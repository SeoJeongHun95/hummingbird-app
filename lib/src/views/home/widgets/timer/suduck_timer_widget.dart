import 'package:StudyDuck/src/viewmodels/app_setting/app_setting_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/enum/mxnRate.dart';
import '../../../../../core/utils/get_formatted_time.dart';
import '../../../../../core/widgets/mxnContainer.dart';
import '../../../../providers/suduck_timer/suduck_timer_provider_2_0.dart';
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
    final isAutoFocus = ref.read(appSettingViewModelProvider).autoFocusMode;

    updateAnimation(bgColor);

    final bool isRunning = suduckTimer.isRunning;

    return MxNcontainer(
      MxN_rate: MxNRate.TWOBYTHREEQUARTERS,
      color: Colors.transparent,
      MxN_child: AnimatedBuilder(
        animation: _colorAnimation,
        builder: (context, child) {
          return Container(
            color: _colorAnimation.value,
            child: Column(
              children: [
                Spacer(flex: 1),
                //과목표시
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
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                  ),
                ),
                //시간
                Expanded(
                  flex: 5,
                  child: Container(
                    width: double.infinity,
                    color: _colorAnimation.value,
                    child: Center(
                      child: Text(
                        getFormatTime(suduckTimer.elapsedTime),
                        style: TextStyle(
                          fontSize: 64.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                  ),
                ),
                //타이머 버튼
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
                                if (isAutoFocus) context.go("/focusMode");
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
                                  (!isRunning)
                                      ? tr("Timer.Start")
                                      : tr("Timer.Pause"),
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
                //컨트롤 보드
                Spacer(flex: 1)
              ],
            ),
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
