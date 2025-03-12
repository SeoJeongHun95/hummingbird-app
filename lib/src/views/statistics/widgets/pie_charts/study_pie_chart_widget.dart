import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/enum/mxnRate.dart';
import '../../../../../core/widgets/mxnContainer.dart';
import 'study_pie_chart.dart';

class StudyPieChartWidget extends StatelessWidget {
  const StudyPieChartWidget(
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
    return MxNcontainer(
      MxN_rate: MxNRate.TWOBYONE,
      MxN_child: LayoutBuilder(builder: (context, constraints) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tr("StudyPieChartWidget.subjectPercentage")),
              SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight * 0.7,
                child: StudyPieChart(
                  subjectTitleList: subjectTitleList,
                  studyDurationList: studyDurationList,
                  subjectColorList: subjectColorList,
                  totalStudyDuration: totalStudyDuration,
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
