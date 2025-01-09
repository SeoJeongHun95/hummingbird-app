import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudyBarChart extends StatelessWidget {
  const StudyBarChart(
      {super.key,
      required this.subjectTitleList,
      required this.studyDurationList,
      required this.colorList});

  final List<String> subjectTitleList;
  final List<int> studyDurationList;
  final List<Color> colorList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BarChart(
        duration: Duration.zero,
        BarChartData(
          barGroups: getBarGroups(subjectTitleList, studyDurationList),
          alignment: BarChartAlignment.spaceAround,
          barTouchData: BarTouchData(
              enabled: false,
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (group) => Colors.transparent,
                tooltipMargin: 0,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    '${rod.toY ~/ 60}h ${(rod.toY % 60).toStringAsFixed(0).padLeft(2, '0')}m',
                    TextStyle(
                      color: Colors.black,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
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
                      style: TextStyle(
                        fontSize: 10.sp,
                      ),
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
            toY: studyDurationList[index] / (60 * 1000),
            width: 13.w,
            color: Colors.blue,
          ),
        ],
        showingTooltipIndicators: [0],
      );
    });
  }
}
