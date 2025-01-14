import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/enum/period_option.dart';
import '../../models/study_record/study_record.dart';
import '../../viewmodels/study_record/study_record_viewmodel.dart';

part 'weekly_statistic_data_provider.g.dart';

@riverpod
Future<(List<StudyRecord>, List<int>)> weeklyStatisticData(
    Ref ref, DateTime currentDate, PeriodOption option) async {
  final (studyRecords, dailyTotalDuration) = await ref
      .read(studyRecordViewModelProvider.notifier)
      .loadStudyRecordsByPeriod(currentDate, option);

  return (studyRecords, dailyTotalDuration);
}
