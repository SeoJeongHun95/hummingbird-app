import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomPieChart extends ConsumerWidget {
  const CustomPieChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectList = getTestList().sublist(0, 4);
    subjectList.sort((a, b) => b.studyTime.compareTo(a.studyTime));
    final total = getTotalTime(subjectList);
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: PieChart(
            PieChartData(
              startDegreeOffset: -90,
              sections: getSections(subjectList, total),
              sectionsSpace: 1,
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Flexible(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: getSubjectStatistics(subjectList, total),
          ),
        )
      ],
    );
  }

  List<PieChartSectionData> getSections(List<TestData> list, int total) {
    return List.generate(list.length, (index) {
      return PieChartSectionData(
        color: list[index].color,
        value: list[index].studyTime.toDouble(),
        title: index == 0 ? getPercentage(list[index].studyTime, total) : '',
        titleStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        radius: 48,
      );
    });
  }

  List<Widget> getSubjectStatistics(List<TestData> list, int total) {
    return list
        .map((e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.5),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8), color: e.color),
                  ),
                  const SizedBox(width: 15),
                  Text(e.title),
                  const Spacer(),
                  Text(getPercentage(e.studyTime, total)),
                ],
              ),
            ))
        .toList();
  }

  int getTotalTime(List<TestData> list) =>
      list.fold(0, (pre, element) => pre + element.studyTime);

  String getPercentage(int value, int total) {
    return '${(value / total * 100).toStringAsFixed(0)}%';
  }
}

class TestData {
  String title;
  Color color;
  int studyTime;

  TestData(this.title, this.color, this.studyTime);
}

List<TestData> getTestList() {
  List<String> subject = ["국어", "수학", "영어", "역사", "물리", "지구과학", "사회과학"];
  List<Color> colorList = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];
  return [
    for (int i = 0; i < subject.length; i++)
      TestData(subject[i], colorList[i], Random().nextInt(100))
  ];
}
