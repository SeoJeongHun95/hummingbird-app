import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/enum/mxnRate.dart';
import '../../../../../core/widgets/mxnContainer.dart';
import 'study_pie_chart.dart';

class StudyPieChartModule extends StatelessWidget {
  const StudyPieChartModule(
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
          child: Stack(
            children: [
              Positioned(
                top: 10.w,
                left: 13.w,
                child: Text(
                  "과목별 비율",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight * 0.7,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StudyPieChart(
                      subjectTitleList: subjectTitleList,
                      studyDurationList: studyDurationList,
                      subjectColorList: subjectColorList,
                      totalStudyDuration: totalStudyDuration,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
