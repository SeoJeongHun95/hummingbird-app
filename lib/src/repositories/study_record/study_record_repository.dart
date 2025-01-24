import 'package:StudyDuck/core/utils/format_date.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/get_formatted_today.dart';
import '../../datasource/local/study_record/study_record_local_datasource.dart';
import '../../datasource/remote/subject_record/add_study_record_api.dart';
import '../../datasource/remote/subject_record/get_study_record_by_date_api.dart';
import '../../datasource/remote/subject_record/get_study_records_by_range_api.dart';
import '../../datasource/remote/subject_record/study_record_remote_datasource.dart';
import '../../models/study_record/study_record.dart';

part 'study_record_repository.g.dart';

@riverpod
StudyRecordRepository studyRecordRepository(Ref ref) {
  final addStudyRecordApi = ref.read(addStudyRecordApiProvider);
  final getStudyRecordByDateApi = ref.read(getStudyRecordByDateApiProvider);
  final getStudyRecordsByRangeApi = ref.read(getStudyRecordsByRangeApiProvider);

  final studyRecordLocalDataSource = StudyRecordDataSource();
  final studyRecordRemoteDatasource = StudyRecordRemoteDatasource(
    addStudyRecordApi: addStudyRecordApi,
    getStudyRecordByDateApi: getStudyRecordByDateApi,
    getStudyRecordsByRangeApi: getStudyRecordsByRangeApi,
  );

  return StudyRecordRepository(
      studyRecordLocalDataSource, studyRecordRemoteDatasource);
}

class StudyRecordRepository {
  final StudyRecordDataSource _localDataSource;
  final StudyRecordRemoteDatasource _remoteDatasource;

  StudyRecordRepository(this._localDataSource, this._remoteDatasource);

  Future<void> addStudyRecord(StudyRecord studyRecord, int totduration) async {
    await _remoteDatasource.addStudyRecordApi.execute(AddStudyRecordApiReqDto(
      date: formattedToday,
      totalDuration: totduration,
      title: studyRecord.title,
      duration: studyRecord.elapsedTime,
      startAt: studyRecord.startAt!,
      endAt: studyRecord.endAt!,
      totalBreak: studyRecord.breakTime,
      color: studyRecord.color,
      order: studyRecord.order,
    ));
    await _localDataSource.addStudyRecord(studyRecord);
  }

  Future<Map<String, List<StudyRecord>>> getStudyRecord(
      int userId, bool isConnected) async {
    if (isConnected) {
      final studyRecord = await _remoteDatasource.getStudyRecordByDateApi
          .execute(
              GetStudyRecordByDateReqDto(userId: userId, date: formattedToday));

      if (studyRecord == null) {
        return _localDataSource.getStudyRecord();
      }

      return {
        formattedToday: studyRecord.studies.map((study) {
          return StudyRecord(
            title: study.title,
            color: study.color,
            order: study.order,
            startAt: study.startAt,
            endAt: study.endAt,
            elapsedTime: study.duration,
            breakTime: study.totalBreak,
          );
        }).toList()
      };
    } else {
      return _localDataSource.getStudyRecord();
    }
  }

  Future<Map<String, List<StudyRecord>>> getStudyRecordByDate(
      String date) async {
    return _localDataSource.getStudyRecordByDate(date);
  }

  Future<Map<String, List<StudyRecord>>> getStudyRecordByRange(
      int userId,
      DateTime startDate,
      DateTime endDate,
      int period,
      bool isConnected) async {
    if (isConnected) {
      final res = await _remoteDatasource.getStudyRecordsByRangeApi.execute(
          GetStudyRecordsByRangeApiReqDto(
              userId: userId,
              startDate: formatDate(startDate),
              endDate: formatDate(endDate)));

      Map<String, List<StudyRecord>> studyRecordMap = {};

      for (var studyRecord in res.studyRecords) {
        studyRecordMap[studyRecord.date] = studyRecord.studies.map((study) {
          return StudyRecord(
            title: study.title,
            color: study.color,
            order: study.order,
            startAt: study.startAt,
            endAt: study.endAt,
            elapsedTime: study.duration,
            breakTime: study.totalBreak,
          );
        }).toList();
      }

      return studyRecordMap;
    } else {
      Map<String, List<StudyRecord>> studyRecordMap = {};
      for (int i = 0; i < period; i++) {
        final date = formatDate(startDate.add(Duration(days: i)));
        final studyRecord = await getStudyRecordByDate(
            formatDate(startDate.add(Duration(days: i))));

        studyRecordMap[date] = studyRecord[date] ?? [];
      }

      return studyRecordMap;
    }
  }

  Future<void> updateStudyRecord(StudyRecord studyRecord) async {
    // final dateString = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // await _remoteDatasource.addStudyRecordApi.execute(AddStudyRecordApiReqDto(
    //   date: dateString,
    //   totalDuration: 300,
    //   // TODO: 총계 시간 전달해주기
    //   title: studyRecord.title,
    //   duration: studyRecord.elapsedTime,
    //   startAt: 123123123,
    //   // TODO: 스타트앳 전달해주기
    //   endAt: studyRecord.endAt! ~/ 1000,
    //   totalBreak: studyRecord.breakTime,
    //   color: studyRecord.color,
    //   order: studyRecord.order,
    // ));
    await _localDataSource.updateStudyRecord(studyRecord);
  }

  Future<void> deleteStudyRecord() async {
    await _localDataSource.deleteStudyRecord();
  }
}
