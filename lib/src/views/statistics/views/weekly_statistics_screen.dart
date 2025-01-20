import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enum/mxnRate.dart';
import '../../../../core/enum/period_option.dart';
import '../../../../core/widgets/mxnContainer.dart';
import '../../../providers/study_record/weekly_statistic_data_provider.dart';
import '../../../viewmodels/study_record/study_record_viewmodel.dart';
import '../widgets/bar_charts/study_bar_chart_module.dart';
import '../widgets/line_charts/total_duratinos_line_chart_module.dart';
import '../widgets/pie_charts/study_pie_chart_module.dart';
import '../widgets/summary_module.dart';

class WeeklyStatisticsScreen extends ConsumerWidget {
  const WeeklyStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studyRecState =
        ref.watch(weeklyStatisticDataProvider(today, PeriodOption.WEEKLY));
    final studyRecViewModel = ref.read(studyRecordViewModelProvider.notifier);

    return studyRecState.when(
        data: (data) {
          final (studyRecords, dailyTotalDuration) = data;
          final (subjectTitleList, studyDurationList, subjectColorList) =
              studyRecViewModel.getStudyRecordsInfo(studyRecords);
          final (sortedTitle, sortedDurations, sortedColors) =
              studyRecViewModel.getStudyRecordsInfo(
                  studyRecViewModel.sortStudyRecords(studyRecords));

          final totalStudyDuration = studyDurationList.fold(0, (a, b) => a + b);

          if (studyRecords.isEmpty || totalStudyDuration == 0) {
            return Column(
              children: [
                SummaryWidget(
                  totalStudyDuration:
                      dailyTotalDuration.fold(0, (a, b) => a + b),
                  selectedPeriod: PeriodOption.WEEKLY,
                  targetMonth: targetMonth,
                  targetWeekStartDate: targetWeekStartDate,
                ),
                MxNcontainer(
                  MxN_rate: MxNRate.TWOBYONE,
                  MxN_child: Container(
                    color: Colors.white,
                    child: Center(
                      child: Text('기록된 데이터가 없습니다'),
                    ),
                  ),
                )
              ],
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                SummaryWidget(
                  totalStudyDuration:
                      dailyTotalDuration.fold(0, (a, b) => a + b),
                  selectedPeriod: PeriodOption.WEEKLY,
                  targetMonth: targetMonth,
                  targetWeekStartDate: targetWeekStartDate,
                ),
                TotalDuratinosLineChartWidget(
                  period: PeriodOption.WEEKLY,
                  dailyTotalDuration: dailyTotalDuration,
                ),
                StudyPieChartWidget(
                  subjectTitleList: sortedTitle,
                  studyDurationList: sortedDurations,
                  subjectColorList: sortedColors,
                  totalStudyDuration: totalStudyDuration,
                ),
                StudyBarChartWidget(
                  subjectTitleList: subjectTitleList,
                  studyDurationList: studyDurationList,
                  subjectColorList: subjectColorList,
                )
              ],
            ),
          );
        },
        error: (error, stackTrace) => Center(
              child: Text('$error'),
            ),
        loading: () => Center(child: CircularProgressIndicator()));
  }

  DateTime get targetWeekStartDate =>
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .subtract(Duration(days: DateTime.now().weekday - 1));

  DateTime get targetMonth =>
      DateTime(DateTime.now().year, DateTime.now().month);

  DateTime get today =>
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
}
