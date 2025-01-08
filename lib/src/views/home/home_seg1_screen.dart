import 'package:flutter/material.dart';

import '../../../core/enum/mxnRate.dart';
import '../../../core/widgets/mxnContainer.dart';
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
          MxNcontainer(
            MxN_rate: MxNRate.TWOBYTWO,
            MxN_child: Container(
              color: Colors.orange,
              child: Center(
                child: Text("과목 리스트들"),
              ),
            ),
          ),
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
