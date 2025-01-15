import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hummingbird/src/viewmodels/study_record/study_record_viewmodel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/study_record/study_record.dart';

part 'daily_summary_data.g.dart';

@riverpod
Future<List<StudyRecord>> dailySummaryData(Ref ref, String date) async {
  final dailyStudyRecords = await ref
      .read(studyRecordViewModelProvider.notifier)
      .loadMergedStudyRecordsByDate(date);
  return dailyStudyRecords;
}
