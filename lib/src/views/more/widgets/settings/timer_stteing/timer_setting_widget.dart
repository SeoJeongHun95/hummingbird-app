import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class TimerSettingWidget extends StatelessWidget {
  const TimerSettingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity(vertical: -4),
      onTap: () {
        context.go("/more/timerSetting");
      },
      leading: Icon(
        Icons.timer_outlined,
        size: 20.w,
      ),
      title: Text(
        tr("TimerSetting.TimeerSetting"),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16.w,
      ),
    );
  }
}
