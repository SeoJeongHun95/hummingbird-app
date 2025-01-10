import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enum/period_option.dart';
import '../../../datasource/local/study_time_dummy_data.dart';
import '../widgets/bar_charts/study_bar_chart_module.dart';
import '../widgets/line_charts/total_duratinos_line_chart_module.dart';
import '../widgets/pie_charts/study_pie_chart_module.dart';
import '../widgets/summary_module.dart';

class MonthlyStatisticsScreen extends ConsumerWidget {
  const MonthlyStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final targetWeekStartDate =
        DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
    final targetMonth = DateTime(DateTime.now().year, DateTime.now().month);

    final studyDurationList = StudyTimeDummyData.studyMonthDurations;
    final subjectTitleList = StudyTimeDummyData.studyTitles;
    final colorList = StudyTimeDummyData.studyColors;

    final (sortedTitle, sortedDurations, sortedColors) =
        StudyTimeDummyData.getSortedList(studyDurationList);
    final totalDurations = StudyTimeDummyData.totalMonthDuration;
    final totalStudyDuration = studyDurationList.fold(0, (a, b) => a + b);

    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            SummaryModule(
              totalStudyDuration: totalDurations.fold(0, (a, b) => a + b),
              selectedPeriod: PeriodOption.MONTHLY,
              targetMonth: targetMonth,
              targetWeekStartDate: targetWeekStartDate,
            ),
            TotalDuratinosLineChartModule(
              period: PeriodOption.MONTHLY,
              totalDurations: totalDurations,
            ),
            StudyPieChartModule(
              subjectTitleList: sortedTitle,
              studyDurationList: sortedDurations,
              colorList: sortedColors,
              totalStudyDuration: totalStudyDuration,
            ),
            StudyBarChartModule(
              subjectTitleList: subjectTitleList,
              studyDurationList: studyDurationList,
              colorList: colorList,
            )
          ]),
        )
      ],
    );
  }
}
