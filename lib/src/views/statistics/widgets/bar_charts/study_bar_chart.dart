import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//TODO: 현재 기존 subject 가 다 0:00:00 으로 나오는데, 이것을 00:00:00 으로 하고, 보여줄 지 말지 결정 필요.
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
                    formatTime(rod.toY),
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
            toY: studyDurationList[index].toDouble(),
            width: 15.w,
            color: Colors.blue,
          ),
        ],
        showingTooltipIndicators: [0],
      );
    });
  }

  String formatTime(double seconds) {
    return '${(seconds ~/ 3600).toString().padLeft(2, '0')}:${(seconds ~/ 60).toStringAsFixed(0).padLeft(2, '0')}:${(seconds % 60).toStringAsFixed(0).padLeft(2, '0')}';
  }
}
