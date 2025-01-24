import 'package:flutter/material.dart';

import 'widgets/subject/subject_list_widget.dart';
import 'widgets/timer/suduck_timer_controll_bar_widget.dart';
import 'widgets/timer/suduck_timer_widget.dart';
//Timer

class Seg1Screen extends StatelessWidget {
  const Seg1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SuDuckTimerWidget(),
          SuduckTimerControllBarWidget(),
          SubjectListWidget(),
        ],
      ),
    );
  }
}
