import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/enum/period_option.dart';
import '../../../core/utils/get_formatted_today.dart';
import '../../models/study_record/study_record.dart';
import '../../providers/network_status/network_state_provider.dart';
import '../../repositories/study_record/study_record_repository.dart';
import '../user_setting/user_setting_view_model.dart';

part 'study_record_viewmodel.g.dart';

@riverpod
class StudyRecordViewModel extends _$StudyRecordViewModel {
  late StudyRecordRepository repository;

  @override
  AsyncValue<List<StudyRecord>> build() {
    repository = ref.watch(studyRecordRepositoryProvider);
    state = const AsyncValue.loading();
    loadStudyRecords();
    return state;
  }

  Future<void> loadStudyRecords() async {
    final isConnected = await ref.watch(networkStateProvider.future);
    final userId = ref.watch(userSettingViewModelProvider).userId;
    state = await AsyncValue.guard(() async {
      final studyRecordsMap =
          await repository.getStudyRecord(userId!, isConnected);
      return studyRecordsMap[formattedToday] ?? [];
    });
  }

  Future<void> addStudyRecord(StudyRecord studyRecord) async {
    await repository.addStudyRecord(studyRecord);
    loadStudyRecords();
  }

  Future<void> updateStudyRecord(StudyRecord studyRecord) async {
    await repository.updateStudyRecord(studyRecord);
    loadStudyRecords();
  }

  Future<void> deleteStudyRecord() async {
    await repository.deleteStudyRecord();
    loadStudyRecords();
  }

  List<StudyRecord> loadMergedStudyRecordsByDate(List<StudyRecord> records) {
    return records
        .fold<Map<String, StudyRecord>>({}, (acc, record) {
          final key = '${record.title}:${record.order}';
          if (acc.containsKey(key)) {
            final existingRecord = acc[key]!;
            acc[key] = existingRecord.copyWith(
              elapsedTime: existingRecord.elapsedTime + record.elapsedTime,
              breakTime: existingRecord.breakTime + record.breakTime,
            );
          } else {
            acc[key] = record;
          }

          return acc;
        })
        .values
        .toList();
  }

  (
    List<String> subjectTitleList,
    List<int> studyDurationList,
    List<Color> subjectColorList
  ) getStudyRecordsInfo(List<StudyRecord> studyRecords) {
    List<String> subjectTitleList = [];
    List<int> studyDurationList = [];
    List<Color> subjectColorList = [];

    for (int i = 0; i < studyRecords.length; i++) {
      subjectTitleList.add(studyRecords[i].title);
      studyDurationList
          .add(studyRecords[i].elapsedTime); // + studyRecords[i].breakTime);
      subjectColorList.add(Color(int.parse('0xff${studyRecords[i].color}')));
    }

    return (subjectTitleList, studyDurationList, subjectColorList);
  }

  List<StudyRecord> sortStudyRecords(List<StudyRecord> records) {
    final sortedRecords = [...records];
    sortedRecords.sort(
      (a, b) =>
          (b.elapsedTime + b.breakTime).compareTo(a.elapsedTime + a.breakTime),
    );
    return sortedRecords;
  }

  Future<(List<StudyRecord>, List<int>)> loadStudyRecordsByPeriod(
      DateTime currentDate, PeriodOption option) async {
    final period = switch (option) {
      PeriodOption.WEEKLY => 7,
      _ => DateUtils.getDaysInMonth(currentDate.year, currentDate.month),
    };
    final startDate = getStartDate(currentDate, option);

    List<StudyRecord> studyRecords = [];

    final dailyTotalDuration = List.generate(period, (index) => 0);

    for (int day = 0; day < period; day++) {
      final studyRecordsMap = await repository
          .getStudyRecordByDate(formatDate(startDate.add(Duration(days: day))));
      final dailyRecords =
          studyRecordsMap[formatDate(startDate.add(Duration(days: day)))] ?? [];

      for (var record in dailyRecords) {
        dailyTotalDuration[day] += record.elapsedTime; //+ record.breakTime;

        final subjectIndex =
            studyRecords.indexWhere((rec) => rec.order == record.order);
        if (subjectIndex != -1) {
          studyRecords[subjectIndex] = studyRecords[subjectIndex].copyWith(
            elapsedTime:
                studyRecords[subjectIndex].elapsedTime + record.elapsedTime,
            breakTime: studyRecords[subjectIndex].breakTime + record.breakTime,
          );
        } else {
          studyRecords.add(record);
        }
      }
    }
    return (studyRecords, dailyTotalDuration);
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  DateTime getStartDate(DateTime currentDate, PeriodOption option) =>
      switch (option) {
        PeriodOption.WEEKLY =>
          currentDate.subtract(Duration(days: DateTime.now().weekday - 1)),
        _ => DateTime(currentDate.year, currentDate.month, 1),
      };
}
