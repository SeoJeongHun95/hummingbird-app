import 'package:StudyDuck/core/widgets/admob_widget.dart';
import 'package:flutter/material.dart';

import '../../../core/enum/mxnRate.dart';
import '../../../core/widgets/mxnContainer.dart';
import 'widgets/daily_summary/daily_statistics_widget.dart';
import 'widgets/grass/study_grass_widget.dart';

//요약
class Seg3Screen extends StatelessWidget {
  const Seg3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          MxNcontainer(
            MxN_rate: MxNRate.TWOBYTHREEQUARTERS,
            MxN_child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: const StudyGrassWidget(),
            ),
          ),
          const SizedBox(height: 8),
          DailyStatisticsWidget(),
        ],
      ),
    );
  }
}
