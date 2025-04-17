import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../models/grass/grass_data_model.dart';

class GrassGrid extends StatelessWidget {
  /// studyData 매개변수를 통해 학습 데이터 리스트를 전달받음
  final List<GrassDataModel> grassData;

  const GrassGrid({
    Key? key,
    required this.grassData,
  }) : super(key: key);

  Color _getColorForStudyCount(int count) {
    if (count == 0) return Colors.grey[300]!;
    if (count <= 2) return Colors.green[100]!;
    if (count <= 4) return Colors.green[300]!;
    if (count <= 6) return Colors.green[500]!;
    return Colors.green[700]!;
  }

  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startDate = now.subtract(const Duration(days: 16 * 7));

    // Create a map of study counts by date
    final studyCountMap = {
      for (var data in grassData) _getDateKey(data.studyDay): data.studyCount
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(DateFormat('MM/dd').format(startDate)),
              Text(DateFormat('MM/dd').format(now)),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            // 요일 열
            Column(
              children: List.generate(7, (dayIndex) {
                final day = ['월', '화', '수', '목', '금', '토', '일'][dayIndex];
                return Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(2),
                  child: Text(
                    day,
                    style: TextStyle(fontSize: 12),
                  ),
                );
              }),
            ),
            // 잔디 그리드
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(16, (weekIndex) {
                    final weekStartDate =
                        startDate.add(Duration(days: weekIndex * 7));
                    return Column(
                      children: List.generate(7, (dayIndex) {
                        final currentDate =
                            weekStartDate.add(Duration(days: dayIndex));
                        final dateKey = _getDateKey(currentDate);
                        final studyCount = studyCountMap[dateKey] ?? 0;

                        return Container(
                          width: 20,
                          height: 20,
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: _getColorForStudyCount(studyCount),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
