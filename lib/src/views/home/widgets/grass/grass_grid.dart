import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:math' as math;
import '../../../../models/grass/grass_data_model.dart';

class GrassGrid extends StatelessWidget {
  /// studyData 매개변수를 통해 학습 데이터 리스트를 전달받음
  final List<GrassDataModel> grassData;

  const GrassGrid({
    Key? key,
    required this.grassData,
  }) : super(key: key);

  Color _getColorForStudyDuration(int durationInSeconds) {
    final hours = durationInSeconds / 3600; // 초를 시간으로 변환
    if (durationInSeconds == 0) return Colors.grey[300]!;
    if (hours <= 1) return Colors.green[100]!; // 1시간 이하
    if (hours <= 2) return Colors.green[300]!; // 2시간 이하
    if (hours <= 4) return Colors.green[500]!; // 4시간 이하
    return Colors.green[700]!; // 4시간 초과
  }

  String _getDateKey(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  DateTime _getStartDate() {
    final now = DateTime.now();
    // 이전 달의 첫 날
    final startOfPrevMonth = DateTime(now.year, now.month - 1, 1);
    // 첫 번째 월요일을 찾습니다
    var startDate = startOfPrevMonth;
    while (startDate.weekday != 1) {
      startDate = startDate.subtract(const Duration(days: 1));
    }
    return startDate;
  }

  int _getWeeksInTwoMonths() {
    final now = DateTime.now();
    final lastDayOfCurrentMonth = DateTime(now.year, now.month + 1, 0);
    final startDate = _getStartDate();
    final diffDays = lastDayOfCurrentMonth.difference(startDate).inDays + 1;
    return (diffDays / 7).ceil();
  }

  String _getMonthRangeText() {
    final now = DateTime.now();
    final prevMonth = DateTime(now.year, now.month - 1);
    return '${DateFormat('yyyy년 MM월').format(prevMonth)} - ${DateFormat('MM월').format(now)}';
  }

  Size _calculateOptimalCellSize(BuildContext context, int weeksCount) {
    final screenSize = MediaQuery.of(context).size;
    final horizontalPadding = 32.0; // 좌우 패딩 16.0 * 2
    final monthRangeHeight = 20.0; // 연도와 월 표시 영역
    final monthRangeMargin = 2.0; // 연도와 월 아래 마진
    final legendHeight = 1.0; // 범례 영역
    final legendMargin = 4.0; // 범례 위아래 마진
    final containerPadding = 5.0; // 컨테이너 내부 패딩
    final totalVerticalPadding = monthRangeHeight +
        monthRangeMargin +
        legendHeight +
        (legendMargin * 2) +
        (containerPadding * 2);

    final cellMargin = 2.0;

    // 가로 방향 계산
    final totalColumns = weeksCount + 1; // 요일 열 포함
    final availableWidth = screenSize.width - horizontalPadding;
    final maxCellWidth =
        (availableWidth - (totalColumns * cellMargin)) / totalColumns;

    // 세로 방향 계산 (화면 높이의 25%를 최대로 사용)
    final maxContainerHeight = screenSize.height * 0.25;
    final availableHeight = maxContainerHeight - totalVerticalPadding;
    final maxCellHeight = (availableHeight - (7 * cellMargin)) / 7;

    // 가로와 세로 중 작은 값을 선택하여 정사각형 셀 생성
    final cellSize = math.min(maxCellWidth, maxCellHeight);

    return Size(cellSize, cellSize);
  }

  @override
  Widget build(BuildContext context) {
    final startDate = _getStartDate();
    final now = DateTime.now();
    final weeksInTwoMonths = _getWeeksInTwoMonths();
    final cellSize = _calculateOptimalCellSize(context, weeksInTwoMonths);
    final cellMargin = 2.0;

    // Create a map of study durations by date
    final studyDurationMap = {
      for (var data in grassData) _getDateKey(data.studyDay): data.studyDuration
    };

    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getMonthRangeText(),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[200]!, width: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    // 요일 열
                    Column(
                      children: List.generate(7, (dayIndex) {
                        final day =
                            ['월', '화', '수', '목', '금', '토', '일'][dayIndex];
                        return Container(
                          width: cellSize.width,
                          height: cellSize.height,
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(cellMargin / 2),
                          child: Text(
                            day,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                          ),
                        );
                      }),
                    ),
                    // 잔디 그리드
                    Row(
                      children: List.generate(weeksInTwoMonths, (weekIndex) {
                        final weekStartDate =
                            startDate.add(Duration(days: weekIndex * 7));
                        return Column(
                          children: List.generate(7, (dayIndex) {
                            final currentDate =
                                weekStartDate.add(Duration(days: dayIndex));
                            final isInRange = currentDate.month == now.month ||
                                currentDate.month == now.month - 1;
                            final dateKey = _getDateKey(currentDate);
                            final studyDuration =
                                studyDurationMap[dateKey] ?? 0;

                            return Container(
                              width: cellSize.width,
                              height: cellSize.height,
                              margin: EdgeInsets.all(cellMargin / 2),
                              decoration: BoxDecoration(
                                color: isInRange
                                    ? _getColorForStudyDuration(studyDuration)
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 0.5,
                                ),
                              ),
                            );
                          }),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  tr('StudyGrass.StudyTime'),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(width: 8),
                _buildLegendItem('0h', Colors.grey[300]!),
                _buildLegendItem('~1h', Colors.green[100]!),
                _buildLegendItem('~2h', Colors.green[300]!),
                _buildLegendItem('~4h', Colors.green[500]!),
                _buildLegendItem('4h+', Colors.green[700]!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
