import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../chart_scroll_view.dart';

class TotalDurationsLineChart extends StatelessWidget {
  const TotalDurationsLineChart(
      {super.key, required this.selectedPeriod, required this.totalDurations});

  final PeriodOption selectedPeriod;
  final List<int> totalDurations;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.w, right: 16.w, bottom: 8.w),
      child: LineChart(
        duration: Duration.zero,
        LineChartData(
          lineTouchData: LineTouchData(
            getTouchedSpotIndicator: (barData, spotIndexes) =>
                spotIndexes.map((index) => null).toList(),
            touchTooltipData: LineTouchTooltipData(
              fitInsideHorizontally: true,
              tooltipRoundedRadius: 8,
              tooltipPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              getTooltipColor: (touchedSpot) => Colors.blue,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((barSpot) {
                  return LineTooltipItem(
                      '${barSpot.y.floor().toString()}h ${((barSpot.y % 1) * 60).floor().toStringAsFixed(0).padLeft(2, '0')}m',
                      TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500));
                }).toList();
              },
            ),
          ),
          minY: 0,
          maxY: 24,
          maxX: selectedPeriod == PeriodOption.weekly
              ? 7
              : DateUtils.getDaysInMonth(
                      DateTime.now().year, DateTime.now().month)
                  .toDouble(),
          lineBarsData: [lineBarData],
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            drawHorizontalLine: true,
            horizontalInterval: 6,
          ),
          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles()),
            rightTitles: AxisTitles(sideTitles: SideTitles()),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 25.w,
                  maxIncluded: selectedPeriod == PeriodOption.weekly,
                  interval: selectedPeriod == PeriodOption.weekly ? 1 : 5,
                  getTitlesWidget: bottomTitleWidgets),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 6,
                reservedSize: 30.w,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<String> get weekDays => ['월', '화', '수', '목', '금', '토', '일'];

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    switch (selectedPeriod) {
      case PeriodOption.weekly:
        return SideTitleWidget(
            axisSide: AxisSide.bottom,
            child: Text(weekDays[value.toInt() - 1]));
      default:
        return SideTitleWidget(
          axisSide: AxisSide.bottom,
          child: Text('${value.toInt()}'),
        );
    }
  }

  LineChartBarData get lineBarData {
    return LineChartBarData(
      isStepLineChart: selectedPeriod == PeriodOption.weekly,
      barWidth: 3,
      isCurved: true,
      preventCurveOverShooting: true,
      color: Colors.blue,
      dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) {
            return FlDotCirclePainter(
              radius: 2,
              color: Colors.white,
              strokeWidth: 3,
              strokeColor: Colors.blue,
            );
          }),
      spots: List.generate(
        totalDurations.length,
        (index) => FlSpot(
          (index + 1).toDouble(),
          totalDurations[index] / (3600 * 1000),
        ),
      ),
    );
  }
}
