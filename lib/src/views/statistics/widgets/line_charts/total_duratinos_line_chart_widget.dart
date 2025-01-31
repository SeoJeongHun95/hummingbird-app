import 'package:flutter/material.dart';

import '../../../../../core/enum/mxnRate.dart';
import '../../../../../core/enum/period_option.dart';
import '../../../../../core/widgets/mxnContainer.dart';
import 'total_durations_line_chart.dart';

class TotalDuratinosLineChartWidget extends StatelessWidget {
  const TotalDuratinosLineChartWidget(
      {super.key, required this.period, required this.dailyTotalDuration});

  final PeriodOption period;
  final List<int> dailyTotalDuration;

  @override
  Widget build(BuildContext context) {
    return MxNcontainer(
      MxN_rate: MxNRate.TWOBYTHREEQUARTERS,
      MxN_child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("하루 총 공부시간"),
            Expanded(
              child: TotalDurationsLineChart(
                selectedPeriod: period,
                dailyTotalDuration: dailyTotalDuration,
              ),
            )
          ],
        ),
      ),
    );
  }
}
