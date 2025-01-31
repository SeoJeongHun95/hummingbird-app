import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class StudyPieChart extends StatelessWidget {
  const StudyPieChart(
      {super.key,
      required this.subjectTitleList,
      required this.studyDurationList,
      required this.subjectColorList,
      required this.totalStudyDuration});

  final List<String> subjectTitleList;
  final List<int> studyDurationList;
  final List<Color> subjectColorList;
  final int totalStudyDuration;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 3,
          child: PieChart(
            duration: Duration.zero,
            PieChartData(
              startDegreeOffset: -90,
              sections: getSections(subjectTitleList, studyDurationList,
                  subjectColorList, totalStudyDuration),
              sectionsSpace: 1,
            ),
          ),
        ),
        const Spacer(flex: 1),
        Flexible(
          flex: 3,
          child: SingleChildScrollView(
            child: Column(
              children: getLegend(subjectTitleList, studyDurationList,
                  subjectColorList, totalStudyDuration),
            ),
          ),
        )
      ],
    );
  }

  List<PieChartSectionData> getSections(List<String> subjectTitleList,
      List<int> studyDurationList, List<Color> subjectColorList, int total) {
    return List.generate(studyDurationList.length, (index) {
      return PieChartSectionData(
        color: subjectColorList[index],
        titlePositionPercentageOffset: 0.5,
        value: studyDurationList[index].toDouble(),
        title: index == 0
            ? '${(studyDurationList[index] * 100 / total).toStringAsFixed(1)}%'
            : '',
        titleStyle: TextStyle(fontSize: 12),
      );
    });
  }

  List<Widget> getLegend(List<String> subjectTitleList,
      List<int> studyDurationList, List<Color> subjectColorList, int total) {
    final percentageList = calculatePercentage(studyDurationList, total);
    return List.generate(subjectTitleList.length, (index) {
      return Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: subjectColorList[index]),
          ),
          Gap(10.w),
          SizedBox(
            width: 64.w,
            child: Text(
              subjectTitleList[index],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Spacer(),
          Text(percentageList[index])
        ],
      );
    });
  }

  List<String> calculatePercentage(List<int> studyDurationList, int total) {
    double sum = 0.0;
    final List<String> percentageList = <String>[];

    // 마지막 원소는 100 - sum 방식으로 모든 퍼센트의 합이 100이 되도록 설정
    for (int i = 0; i < studyDurationList.length - 1; i++) {
      double tmp = (studyDurationList[i] * 1000 / total).roundToDouble() / 10;
      percentageList.add('${tmp.toStringAsFixed(1)}%');
      sum += tmp;
    }

    if (sum >= 100) {
      percentageList.add('0.0%');
    } else {
      percentageList.add('${(100 - sum).toStringAsFixed(1)}%');
    }

    return percentageList;
  }
}
