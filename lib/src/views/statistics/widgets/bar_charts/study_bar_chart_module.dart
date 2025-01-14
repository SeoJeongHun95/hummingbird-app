import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/enum/mxnRate.dart';
import '../../../../../core/widgets/mxnContainer.dart';
import 'study_bar_chart.dart';

class StudyBarChartModule extends StatelessWidget {
  const StudyBarChartModule(
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
      MxN_rate: MxNRate.FOURBYTHREE,
      MxN_child: LayoutBuilder(builder: (context, constraints) {
        return Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 13.w),
                child: Text(
                  "과목별 공부시간",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  height: constraints.maxHeight * 0.7,
                  width: subjectTitleList.length <= 7
                      ? constraints.maxWidth
                      : constraints.maxWidth +
                          30.w * (subjectTitleList.length - 7),
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
