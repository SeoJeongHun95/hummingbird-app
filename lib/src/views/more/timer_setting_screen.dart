import 'package:StudyDuck/core/widgets/admob_widget.dart';
import 'package:flutter/material.dart';

import '../../../core/enum/mxnRate.dart';
import '../../../core/widgets/mxnContainer.dart';
import 'widgets/settings/timer_stteing/auto_focus_switch_widget.dart';

class TimerSettingScreen extends StatelessWidget {
  const TimerSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              MxNcontainer(
                MxN_rate: MxNRate.TWOBYONE,
                MxN_child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Column(
                    children: [
                      AutoFocusSwitchWidget(),
                      Divider(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: AdMobWidget.showBannerAd(50),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
