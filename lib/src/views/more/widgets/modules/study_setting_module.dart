import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/enum/mxnRate.dart';
import '../setting_container.dart';
import '../setting_tile.dart';

class StudySettingModule extends ConsumerStatefulWidget {
  const StudySettingModule({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StudySettingModuleState();
}

class _StudySettingModuleState extends ConsumerState<StudySettingModule> {
  int goalDuration = 8 * 60 * 60;

  void selectGoal(Duration newDuration) {
    setState(() {
      goalDuration = newDuration.inSeconds;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SettingContainer(settingTiles: settingTiles, rate: MxNRate.TWOBYONE);
  }

  List<Widget> get settingTiles {
    return [
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          showTimePickerBottomModal(context, '시간 선택', goalDuration);
        },
        child: SettingTile(
          title: '목표 공부시간',
          selected: Text(
            formatDuration(goalDuration),
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.grey[700],
            ),
          ),
        ),
      ),
      SettingTile(
        title: '국가',
        selected: Text(
          '대한민국',
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.grey[700],
          ),
        ),
      ),
      SettingTile(title: '그룹'),
    ];
  }

  double get fontSize => 12.sp;

  Future<void> showTimePickerBottomModal(
      BuildContext context, String title, int initialSecond) async {
    Duration initial = Duration(seconds: initialSecond);
    await showModalBottomSheet(
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
                        onPressed: () => Navigator.pop(context),
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
                  initialTimerDuration: initial,
                  onTimerDurationChanged: selectGoal,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> getCarouselTimeItems(int itemCount) {
    return List.generate(
      itemCount,
      (index) => Text(
        index.toString().padLeft(2, '0'),
        style: TextStyle(
          fontSize: 12.sp,
        ),
      ),
    );
  }

  String formatDuration(int duration) {
    int hour = duration ~/ (60 * 60);
    int minute = (duration % (60 * 60)) ~/ 60;
    int second = duration % 60;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}';
  }
}
