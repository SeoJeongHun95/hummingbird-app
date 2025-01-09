import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../datasource/local/study_time_dummy_data.dart';
import 'bar_charts/study_bar_chart_module.dart';
import 'line_charts/total_duratinos_line_chart_module.dart';
import 'pie_charts/study_pie_chart_module.dart';
import 'summary_module.dart';
import 'time_period_segmented_button.dart';

enum PeriodOption { weekly, monthly }

class ChartScrollView extends ConsumerStatefulWidget {
  const ChartScrollView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChartScrollViewState();
}

class _ChartScrollViewState extends ConsumerState<ChartScrollView> {
  late PeriodOption selectedPeriod;
  late DateTime targetMonth;
  late DateTime targetWeekStartDate;

  @override
  void initState() {
    super.initState();
    selectedPeriod = PeriodOption.weekly;
    targetMonth = DateTime(DateTime.now().year, DateTime.now().month);
    targetWeekStartDate =
        DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
  }

  @override
  Widget build(BuildContext context) {
    final studyDurationList = switch (selectedPeriod) {
      PeriodOption.weekly => StudyTimeDummyData.studyDurations,
      _ => StudyTimeDummyData.studyMonthDurations,
    };
    final subjectTitleList = StudyTimeDummyData.studyTitles;
    final colorList = StudyTimeDummyData.studyColors;
    final (sortedTitle, sortedDurations, sortedColors) =
        StudyTimeDummyData.getSortedList(studyDurationList);
    final totalDurations = switch (selectedPeriod) {
      PeriodOption.weekly => StudyTimeDummyData.totalWeekDuration,
      _ => StudyTimeDummyData.totalMonthDuration,
    };
    final totalStudyDuration = studyDurationList.fold(0, (a, b) => a + b);
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          centerTitle: true,
          title: TimePeriodSegmentedButton<PeriodOption>(
            selected: selectedPeriod,
            options: [PeriodOption.weekly, PeriodOption.monthly],
            labels: ['주간', '월간'],
            width: 200.w,
            height: 40.h,
            selectedColor: Colors.white,
            selectedForegroundColor: Colors.black,
            backgroundColor: Color(0xffe0e0e0),
            foregroundColor: Color(0xff4e4e4e),
            labelStyle: TextStyle(fontSize: 15.sp),
            boxShadowColor: Color(0xffb5b5b5),
            onSelected: changePeriod,
          ),
          scrolledUnderElevation: 0,
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            SummaryModule(
              totalStudyDuration: totalDurations.fold(0, (a, b) => a + b),
              selectedPeriod: selectedPeriod,
              targetMonth: targetMonth,
              targetWeekStartDate: targetWeekStartDate,
            ),
            TotalDuratinosLineChartModule(
              period: selectedPeriod,
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

  void changePeriod(int newSelctedIndex) {
    final PeriodOption newSelected = switch (newSelctedIndex) {
      0 => PeriodOption.weekly,
      _ => PeriodOption.monthly,
    };
    setState(() {
      selectedPeriod = newSelected;
    });
  }
}
