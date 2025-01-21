import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/enum/mxnRate.dart';
import '../../../../../core/widgets/mxnContainer.dart';
import '../../../../viewmodels/study_record/study_record_viewmodel.dart';
import '../../../../viewmodels/study_setting/study_setting_view_model.dart';
import '../../../statistics/widgets/bar_charts/study_bar_chart_widget.dart';
import '../../../statistics/widgets/pie_charts/study_pie_chart_widget.dart';
import 'goal_progress_widget.dart';

class DailySummaryWidget extends ConsumerWidget {
  const DailySummaryWidget({super.key});

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
                GoalProgressWidget(
                    totalStudyDuration: 0, goalDuration: goalDuration),
                MxNcontainer(
                  MxN_rate: MxNRate.TWOBYONE,
                  MxN_child: Container(
                    color: Colors.white,
                    child: Center(
                      child: Text('오늘 기록된 데이터가 없습니다'),
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
              GoalProgressWidget(
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
                  subjectColorList: subjectColorList)
            ],
          ),
        );
      },
      error: (error, stackTrace) => Center(
        child: Text('Error: $error'),
      ),
      loading: () => Center(
        child: const CircularProgressIndicator(),
      ),
    );
  }
}
