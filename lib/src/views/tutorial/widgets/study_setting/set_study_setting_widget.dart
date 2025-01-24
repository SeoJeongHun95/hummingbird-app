import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/enum/mxnRate.dart';
import '../../../../../core/utils/get_formatted_time.dart';
import '../../../../../core/widgets/mxnContainer.dart';
import 'select_group_bottom_sheet.dart';

class SetStudySettingWidget extends StatelessWidget {
  const SetStudySettingWidget({
    super.key,
    required this.goalDuration,
    required this.selectedGroup,
    required this.selectGoalDuration,
    required this.selectGroup,
  });

  final int goalDuration;
  final String? selectedGroup;
  final void Function(int duration) selectGoalDuration;
  final void Function(String group) selectGroup;

  @override
  Widget build(BuildContext context) {
    return MxNcontainer(
      MxN_rate: MxNRate.TWOBYONE,
      MxN_child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('목표 공부시간'),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                final selectedDuration = await showTimePickerBottomModal(
                    context, '시간 선택', goalDuration);
                if (selectedDuration != null) {
                  selectGoalDuration(selectedDuration.inSeconds);
                }
              },
              child: Row(
                children: [
                  Text(getFormatTime(goalDuration)),
                  const Spacer(),
                  Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),
            Divider(color: Colors.grey),
            Text('그룹'),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                final selected = await showSelectGroupBottomModal(context);
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
            Divider(color: Colors.grey),
          ],
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
                    Text(title),
                    const Spacer(),
                    TextButton(
                      onPressed: () => Navigator.pop(context, selected),
                      child: Text('완료'),
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
}
