import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/enum/mxnRate.dart';
import '../../../../../core/widgets/mxnContainer.dart';
import '../../../../viewmodels/study_record/study_record_viewmodel.dart';
import '../../../../viewmodels/study_setting/study_setting_view_model.dart';
import '../../../statistics/widgets/bar_charts/study_bar_chart_widget.dart';
import '../../../statistics/widgets/pie_charts/study_pie_chart_widget.dart';
import 'daily_summary_widget.dart';

class DailyStatisticsWidget extends ConsumerWidget {
  const DailyStatisticsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studyRecordsState = ref.watch(studyRecordViewModelProvider);
    final studyRecordViewModel =
        ref.read(studyRecordViewModelProvider.notifier);

    return studyRecordsState.when(
      data: (data) {
        final studyRecords =
            studyRecordViewModel.loadMergedStudyRecordsByDate(data);
        final goalDuration =
            ref.watch(studySettingViewModelProvider).goalDuration;
        if (studyRecords.isEmpty) {
          return SingleChildScrollView(
            child: Column(
              children: [
                DailySummaryWidget(
                    totalStudyDuration: 0, goalDuration: goalDuration),
                MxNcontainer(
                  MxN_rate: MxNRate.TWOBYONE,
                  MxN_child: Container(
                    color: Colors.white,
                    child: Center(
                      child: Text(tr("DailyStatistics.NoData")),
                    ),
                  ),
                )
              ],
            ),
          );
        }

        final (subjectTitleList, studyDurationList, subjectColorList) =
            studyRecordViewModel.getStudyRecordsInfo(studyRecords);

        final (sortedTitleList, sortedDurationList, sortedColorList) =
            studyRecordViewModel.getStudyRecordsInfo(
                studyRecordViewModel.sortStudyRecords(studyRecords));

        final totalStudyDuration = studyDurationList.fold(0, (a, b) => a + b);

        return SingleChildScrollView(
          child: Column(
            children: [
              DailySummaryWidget(
                totalStudyDuration: totalStudyDuration,
                goalDuration: goalDuration,
              ),
              StudyPieChartWidget(
                subjectTitleList: sortedTitleList,
                studyDurationList: sortedDurationList,
                subjectColorList: sortedColorList,
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
        child: Text(tr("DailyStatistics.Error", args: [error.toString()])),
      ),
      loading: () => Center(
        child: const CircularProgressIndicator(),
      ),
    );
  }
}
