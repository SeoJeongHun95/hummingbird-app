import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startDate = now.subtract(const Duration(days: 16 * 7));

    // Create a map of study counts by date
    final studyCountMap = {
      for (var data in grassData) data.studyDay: data.studyCount
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(16, (weekIndex) {
          final weekStartDate = startDate.add(Duration(days: weekIndex * 7));
          return Column(
            children: List.generate(7, (dayIndex) {
              final currentDate = weekStartDate.add(Duration(days: dayIndex));
              final studyCount = studyCountMap[DateTime(
                    currentDate.year,
                    currentDate.month,
                    currentDate.day,
                  )] ??
                  0;

              return Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: _getColorForStudyCount(studyCount),
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}
