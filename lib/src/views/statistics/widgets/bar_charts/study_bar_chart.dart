import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/get_formatted_time.dart';

class StudyBarChart extends StatelessWidget {
  const StudyBarChart(
      {super.key,
      required this.subjectTitleList,
      required this.studyDurationList,
      required this.subjectColorList});

  final List<String> subjectTitleList;
  final List<int> studyDurationList;
  final List<Color> subjectColorList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, left: 24.0),
      child: BarChart(
        duration: Duration.zero,
        BarChartData(
          barGroups: getBarGroups(subjectTitleList, studyDurationList),
          alignment: BarChartAlignment.start,
          groupsSpace: 48.w,
          barTouchData: BarTouchData(
              enabled: false,
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (group) => Colors.transparent,
                tooltipMargin: 2,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    getFormatTime((rod.toY).toInt()),
                    TextStyle(fontSize: 12),
                  );
                },
              )),
          borderData: FlBorderData(
            border: Border(
              top: BorderSide.none,
              right: BorderSide.none,
              left: BorderSide.none,
              bottom: BorderSide.none,
            ),
          ),
          gridData: FlGridData(
            show: false,
          ),
          titlesData: FlTitlesData(
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40.w,
                getTitlesWidget: (value, meta) => SizedBox(
                  width: 40.w,
                  child: Center(
                    child: Text(
                      subjectTitleList[value.toInt()],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> getBarGroups(
      List<String> subjectTitleList, List<int> studyDurationList) {
    return List.generate(subjectTitleList.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: studyDurationList[index].toDouble(),
            width: 16.w,
            color: Colors.blue,
          ),
        ],
        showingTooltipIndicators: [0],
      );
    });
  }
}
