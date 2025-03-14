import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/enum/period_option.dart';
import '../../../../../core/utils/get_formatted_time.dart';

class TotalDurationsLineChart extends StatelessWidget {
  const TotalDurationsLineChart(
      {super.key,
      required this.selectedPeriod,
      required this.dailyTotalDuration});

  final PeriodOption selectedPeriod;
  final List<int> dailyTotalDuration;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0, right: 16.0),
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
                      getFormatTime((barSpot.y * 3600).toInt()),
                      TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500));
                }).toList();
              },
            ),
          ),
          minY: 0,
          maxY: 24,
          maxX: selectedPeriod == PeriodOption.WEEKLY
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
                reservedSize: 28,
                interval: selectedPeriod == PeriodOption.WEEKLY ? 1 : 7,
                getTitlesWidget: bottomTitleWidgets,
              ),
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

  List<String> get weekDays => ['', '월', '화', '수', '목', '금', '토', '일'];

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    switch (selectedPeriod) {
      case PeriodOption.WEEKLY:
        return SideTitleWidget(
            axisSide: AxisSide.bottom, child: Text(weekDays[value.toInt()]));
      default:
        return SideTitleWidget(
          axisSide: AxisSide.bottom,
          child: Text('${value.toInt()}'),
        );
    }
  }

  LineChartBarData get lineBarData {
    final period = switch (selectedPeriod) {
      PeriodOption.WEEKLY => DateTime.now().weekday,
      _ => DateTime.now().day,
    };

    return LineChartBarData(
      isStepLineChart: selectedPeriod == PeriodOption.WEEKLY,
      barWidth: 3,
      isCurved: true,
      preventCurveOverShooting: true,
      color: Colors.blue,
      dotData: FlDotData(
          show: true,
          checkToShowDot: (spot, barData) {
            return spot.x == period;
          },
          getDotPainter: (spot, percent, barData, index) {
            return FlDotCirclePainter(
              radius: 2,
              color: Colors.white,
              strokeWidth: 3,
              strokeColor: Colors.blue,
            );
          }),
      spots: List.generate(
        period,
        (index) => FlSpot(
          (index + 1).toDouble(),
          dailyTotalDuration[index] / 3600,
        ),
      ),
    );
  }

  String formatTime(double seconds) {
    return '${(seconds ~/ 3600).toString().padLeft(2, '0')}:${(seconds ~/ 60).toStringAsFixed(0).padLeft(2, '0')}:${(seconds % 60).toStringAsFixed(0).padLeft(2, '0')}';
  }
}
