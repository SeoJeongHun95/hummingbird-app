import 'package:StudyDuck/src/viewmodels/study_setting/study_setting_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../setting_tile_widget.dart';

class SelectGoalDurationButtonWidget extends ConsumerWidget {
  const SelectGoalDurationButtonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studySetting = ref.watch(studySettingViewModelProvider);
    final studySettingViewModel =
        ref.read(studySettingViewModelProvider.notifier);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        final selectedDuration = await showTimePickerBottomModal(
            context, '시간 선택', studySetting.goalDuration);
        if (selectedDuration != null) {
          studySettingViewModel.updateStudySetting(
              updatedGoalDuration: selectedDuration.inSeconds);
        }
      },
      child: SettingTileWidget(
        title: '목표 공부시간',
        selected: Text(
          formatDuration(studySetting.goalDuration),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
              ),
        ),
        trailing: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.grey[700],
          size: 20.w,
        ),
        padBetweenST: 12.w,
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
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(title),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: TextButton(
                        onPressed: () => Navigator.pop(context, selected),
                        child: Text('완료'),
                      ),
                    ),
                  ],
                ),
                Gap(20.h),
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

  String formatDuration(int duration) {
    int hour = duration ~/ (60 * 60);
    int minute = (duration % (60 * 60)) ~/ 60;
    int second = duration % 60;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}';
  }
}
