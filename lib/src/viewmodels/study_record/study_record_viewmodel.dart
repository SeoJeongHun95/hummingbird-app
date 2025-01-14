import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/enum/period_option.dart';
import '../../models/study_record/study_record.dart';
import '../../repositories/study_record/study_record_repository.dart';
import '../subject/subject_viewmodel.dart';

part 'study_record_viewmodel.g.dart';

@riverpod
class StudyRecordViewModel extends _$StudyRecordViewModel {
  late StudyRecordRepository repository;

  @override
  AsyncValue<List<StudyRecord>> build() {
    repository = ref.watch(studyRecordRepositoryProvider);
    state = const AsyncValue.loading();
    return state;
  }

  // 날짜별로 학습 기록을 불러오는 메서드
  Future<void> loadStudyRecordsByDate(String date) async {
    state = await AsyncValue.guard(() async {
      return await repository.getStudyRecordsByDate(date);
    });
  }

  // 학습 기록을 추가하는 메서드
  Future<void> addStudyRecord(String date, StudyRecord studyRecord) async {
    await repository.addStudyRecord(date, studyRecord);
    loadStudyRecordsByDate(date); // 추가 후 해당 날짜의 학습 기록을 다시 로드
  }

  // 학습 기록을 업데이트하는 메서드
  Future<void> updateStudyRecord(String date, StudyRecord studyRecord) async {
    await repository.updateStudyRecord(date, studyRecord);
    loadStudyRecordsByDate(date); // 업데이트 후 해당 날짜의 학습 기록을 다시 로드
  }

  Future<void> deleteStudyRecord(String date) async {
    await repository.deleteStudyRecord(date);
    loadStudyRecordsByDate(date); // 업데이트 후 해당 날짜의 학습 기록을 다시 로드
  }

  // 날짜별로 받아온 학습 기록 합쳐서 로드하는 메서드
  Future<void> loadMergedStudyRecordsByDate(String date) async {
    state = await AsyncValue.guard(() async {
      List<StudyRecord> records = await repository.getStudyRecordsByDate(date);
      return records
          .fold<Map<String, StudyRecord>>({}, (acc, record) {
            final key = '${record.subject.title}:${record.subject.order}';
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
    });
  }

  //StudyRecords 를 subjectTitle, 총 공부시간, subjectColor 리스트로 분리시켜 Record 로 반환하는 메서드
  (
    List<String> subjectTitleList,
    List<int> studyDurationList,
    List<Color> subjectColorList
  ) getStudyRecordsInfo(List<StudyRecord> studyRecords) {
    List<String> subjectTitleList = [];
    List<int> studyDurationList = [];
    List<Color> subjectColorList = [];

    for (int i = 0; i < studyRecords.length; i++) {
      subjectTitleList.add(studyRecords[i].subject.title);
      studyDurationList
          .add(studyRecords[i].elapsedTime + studyRecords[i].breakTime);
      subjectColorList
          .add(Color(int.parse('0xff${studyRecords[i].subject.color}')));
    }

    return (subjectTitleList, studyDurationList, subjectColorList);
  }

  // StudyRecord 리스트를 공부시간 기준 내림차순 정렬
  List<StudyRecord> sortStudyRecords(List<StudyRecord> records) {
    final sortedRecords = [...records];
    sortedRecords.sort(
      (a, b) =>
          (b.elapsedTime + b.breakTime).compareTo(a.elapsedTime + a.breakTime),
    );
    return sortedRecords;
  }

  //학습 기록을 특정기간으로 가져오는 메서드
  Future<(List<StudyRecord>, List<int>)> loadStudyRecordsByPeriod(
      DateTime currentDate, PeriodOption option) async {
    await ref.read(subjectViewModelProvider.notifier).loadSubjects();
    final subjectState = ref.read(subjectViewModelProvider);

    final subjects = subjectState.value ?? [];

    // 기간 설정 및 시작 날짜 계산
    final period = switch (option) {
      PeriodOption.WEEKLY => 7,
      _ => DateUtils.getDaysInMonth(currentDate.year, currentDate.month),
    };
    final startDate = getStartDate(currentDate, option);
    print("start date: $startDate");

    List<StudyRecord> studyRecords = List.generate(
        subjects.length, (index) => StudyRecord(subject: subjects[index]));

    final dailyTotalDuration = List.generate(period, (index) => 0);
    // 각 기간별 데이터 누적 처리
    for (int day = 0; day < period; day++) {
      final dailyRecords = await repository.getStudyRecordsByDate(
          formatDate(startDate.add(Duration(days: day))));

      for (var record in dailyRecords) {
        dailyTotalDuration[day] += record.elapsedTime + record.breakTime;

        final subjectIndex =
            studyRecords.indexWhere((rec) => rec.subject == record.subject);
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
