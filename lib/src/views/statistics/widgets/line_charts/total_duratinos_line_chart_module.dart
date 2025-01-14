import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/enum/mxnRate.dart';
import '../../../../../core/enum/period_option.dart';
import '../../../../../core/widgets/mxnContainer.dart';
import 'total_durations_line_chart.dart';

class TotalDuratinosLineChartModule extends StatelessWidget {
  const TotalDuratinosLineChartModule(
      {super.key, required this.period, required this.dailyTotalDuration});

  final PeriodOption period;
  final List<int> dailyTotalDuration;

  @override
  Widget build(BuildContext context) {
    return MxNcontainer(
      MxN_rate: MxNRate.FOURBYTHREE,
      MxN_child: LayoutBuilder(builder: (context, constraints) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.all(4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 13.w),
                child: Text(
                  "하루 총 공부시간",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: constraints.maxHeight * 0.7,
                child: TotalDurationsLineChart(
                  selectedPeriod: period,
                  dailyTotalDuration: dailyTotalDuration,
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
