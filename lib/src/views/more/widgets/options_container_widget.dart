import 'package:flutter/material.dart';

import '../../../../core/enum/mxnRate.dart';
import '../../../../core/widgets/mxnContainer.dart';
import 'settings/mbti_resoult/mbti_resoult_widget.dart';
import 'settings/setting_button_widget.dart';
import 'settings/timer_stteing/timer_setting_widget.dart';

class OptionsContainerWidget extends StatelessWidget {
  const OptionsContainerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MxNcontainer(
      MxN_rate: MxNRate.TWOBYONE,
      MxN_child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        child: Column(
          children: [
            MbtiResoultWidget(),
            const Divider(),
            TimerSettingWidget(),
            const Divider(),
            // NotificationButton(),
            // const Divider(),
            SettingButtonWidget(),
          ],
        ),
      ),
    );
  }
}
