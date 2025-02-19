import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/enum/period_option.dart';
import '../../models/study_record/study_record.dart';
import '../../repositories/study_record/study_record_repository.dart';

part 'study_record_viewmodel.g.dart';

//CI/CD 테스트트

@Riverpod(keepAlive: true)
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
    state = await AsyncValue.guard(() async {
      return await repository.getStudyRecord();
    });
  }

  Future<void> addStudyRecord(StudyRecord studyRecord) async {
    await repository.addStudyRecord(studyRecord);
    await loadStudyRecords();
  }

  List<StudyRecord> loadMergedStudyRecordsByDate(List<StudyRecord> records) {
    return records
        .fold<Map<String, StudyRecord>>({}, (acc, record) {
          final key = record.title;
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
      studyDurationList.add(studyRecords[i].elapsedTime);
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

  // Future<(List<StudyRecord>, List<int>)> loadStudyRecordsByPeriod(
  //     DateTime currentDate, PeriodOption option) async {
  //   final period = switch (option) {
  //     PeriodOption.WEEKLY => 7,
  //     _ => DateUtils.getDaysInMonth(currentDate.year, currentDate.month),
  //   };
  //   final startDate = getStartDate(currentDate, option);

  //   List<StudyRecord> studyRecords = [];

  //   final dailyTotalDuration = List.generate(period, (index) => 0);
  //   final studyRecordsMap =
  //       await repository.getStudyRecordByRange(startDate, currentDate, period);

  //   for (int day = 0; day < period; day++) {
  //     final dailyRecords =
  //         studyRecordsMap[formatDate(startDate.add(Duration(days: day)))] ?? [];

  //     for (var record in dailyRecords) {
  //       dailyTotalDuration[day] += record.elapsedTime;

  //       final subjectIndex =
  //           studyRecords.indexWhere((rec) => rec.title == record.title);
  //       if (subjectIndex != -1) {
  //         studyRecords[subjectIndex] = studyRecords[subjectIndex].copyWith(
  //           elapsedTime:
  //               studyRecords[subjectIndex].elapsedTime + record.elapsedTime,
  //           breakTime: studyRecords[subjectIndex].breakTime + record.breakTime,
  //         );
  //       } else {
  //         studyRecords.add(record);
  //       }
  //     }
  //   }
  //   return (studyRecords, dailyTotalDuration);
  // }

  Future<(List<StudyRecord>, List<int>)> loadStudyRecordsByPeriod(
      DateTime currentDate, PeriodOption option) async {
    final startDate = getStartDate(currentDate, option);
    final endDate = currentDate;

    final studyRecords = await repository.getStudyRecord();

    final filteredRecords = studyRecords.where((record) {
      final recordDate =
          DateTime.fromMillisecondsSinceEpoch(record.startAt ?? 0);
      return recordDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
          recordDate.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();

    final period = option == PeriodOption.WEEKLY
        ? 7
        : DateUtils.getDaysInMonth(currentDate.year, currentDate.month);

    final dailyTotalDuration = List.generate(period, (index) => 0);
    List<StudyRecord> aggregatedRecords = [];

    for (var record in filteredRecords) {
      final recordDate =
          DateTime.fromMillisecondsSinceEpoch(record.startAt ?? 0);
      final dayIndex = recordDate.difference(startDate).inDays;

      if (dayIndex >= 0 && dayIndex < period) {
        dailyTotalDuration[dayIndex] += record.elapsedTime;
      }

      final subjectIndex =
          aggregatedRecords.indexWhere((rec) => rec.title == record.title);
      if (subjectIndex != -1) {
        aggregatedRecords[subjectIndex] =
            aggregatedRecords[subjectIndex].copyWith(
          elapsedTime:
              aggregatedRecords[subjectIndex].elapsedTime + record.elapsedTime,
          breakTime:
              aggregatedRecords[subjectIndex].breakTime + record.breakTime,
        );
      } else {
        aggregatedRecords.add(record);
      }
    }

    return (aggregatedRecords, dailyTotalDuration);
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
