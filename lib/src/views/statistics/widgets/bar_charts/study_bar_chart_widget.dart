import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/enum/mxnRate.dart';
import '../../../../../core/widgets/mxnContainer.dart';
import 'study_bar_chart.dart';

class StudyBarChartWidget extends StatelessWidget {
  const StudyBarChartWidget(
      {super.key,
      required this.subjectTitleList,
      required this.studyDurationList,
      required this.subjectColorList});

  final List<String> subjectTitleList;
  final List<int> studyDurationList;
  final List<Color> subjectColorList;

  @override
  Widget build(BuildContext context) {
    return MxNcontainer(
      MxN_rate: MxNRate.TWOBYTHREEQUARTERS,
      MxN_child: LayoutBuilder(builder: (context, constraints) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tr("StudyBarChartWidget.subjectStudyTime")),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  height: constraints.maxHeight * 0.8,
                  width: subjectTitleList.length <= 4
                      ? constraints.maxWidth
                      : constraints.maxWidth +
                          48.w * (subjectTitleList.length - 4),
                  child: StudyBarChart(
                      subjectTitleList: subjectTitleList,
                      studyDurationList: studyDurationList,
                      subjectColorList: subjectColorList),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
