import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/enum/mxnRate.dart';
import '../../../core/widgets/mxnContainer.dart';
import '../../viewmodels/study_setting/study_setting_view_model.dart';
import '../../viewmodels/user_setting/user_setting_view_model.dart';
import 'widgets/page_transition_button_widget.dart';
import 'widgets/select_group_bottom_sheet.dart';

class StudySettingScreen extends ConsumerStatefulWidget {
  const StudySettingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StudySettingScreenState();
}

class _StudySettingScreenState extends ConsumerState<StudySettingScreen> {
  late int goalDuration;
  String? selectedGroup;

  @override
  void initState() {
    super.initState();
    goalDuration = ref.read(studySettingViewModelProvider).goalDuration;
  }

  void selectGroup(String group) {
    setState(() {
      selectedGroup = group;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: bottomPadding, bottom: bottomPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MxNcontainer(
                MxN_rate: MxNRate.TWOBYTHREEQUARTERS,
                MxN_child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('목표 공부시간'),
                      SizedBox(height: 32.w),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () async {
                          final selectedDuration =
                              await showTimePickerBottomModal(
                                  context, '시간 선택', goalDuration);
                          if (selectedDuration != null) {
                            setState(() {
                              goalDuration = selectedDuration.inSeconds;
                            });
                          }
                        },
                        child: Row(
                          children: [
                            Text(formatDuration(goalDuration)),
                            const Spacer(),
                            Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                      ),
                      divder,
                      SizedBox(height: 36.w),
                      Text('그룹'),
                      SizedBox(height: 32.w),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () async {
                          final selected =
                              await showSelectGroupBottomModal(context);
                          if (selected != null) {
                            selectGroup(selected);
                          }
                        },
                        child: Row(
                          children: [
                            Text(selectedGroup ?? ''),
                            const Spacer(),
                            Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                      ),
                      divder,
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PageTransitionButtonWidget(
                    title: '이전',
                    backgroundColor: Colors.white,
                    foregroudColor: Theme.of(context).colorScheme.primary,
                    changePage: () {
                      context.pop();
                    },
                  ),
                  PageTransitionButtonWidget(
                    title: '완료',
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroudColor: Colors.white,
                    changePage: () async {
                      ref
                          .read(studySettingViewModelProvider.notifier)
                          .updateStudySetting(
                              updatedGoalDuration: goalDuration,
                              updatedGroup: selectedGroup);
                      await ref
                          .read(userSettingViewModelProvider.notifier)
                          .updateUserSetting();
                      if (context.mounted) {
                        context.go('/');
                      }
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<Duration?> showTimePickerBottomModal(
      BuildContext context, String title, int initialSecond) async {
    Duration selected = Duration(seconds: initialSecond);

    return await showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 280.h,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: TextButton(
                        onPressed: () => Navigator.pop(context, selected),
                        child: Text(
                          '완료',
                          style: TextStyle(
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hm,
                  initialTimerDuration: selected,
                  onTimerDurationChanged: (newDuration) {
                    selected = newDuration;
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String?> showSelectGroupBottomModal(BuildContext context) async {
    return await showModalBottomSheet(
      context: context,
      builder: (context) {
        return SelectGroupBottomSheet(selectedGroup: selectedGroup);
      },
    );
  }

  String formatDuration(int duration) {
    int hour = duration ~/ (60 * 60);
    int minute = (duration % (60 * 60)) ~/ 60;
    int second = duration % 60;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}';
  }

  Widget get divder => Divider(height: 1, color: Colors.grey);

  double get bottomPadding => 48.0;
}
