import 'package:flutter/material.dart';
import 'package:hummingbird/src/views/home/widgets/subject/subject_list_widget.dart';

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
          SubjectListWidget(),
          // 임시 광고
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Container(
              height: 60,
              color: Colors.yellow,
              child: Center(
                child: Text("ads"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
