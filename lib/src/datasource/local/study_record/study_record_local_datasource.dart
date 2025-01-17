import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/utils/get_formatted_today.dart';
import '../../../models/study_record/study_record.dart';

class StudyRecordDataSource {
  StudyRecordDataSource();

  Future<Box<StudyRecord>> _getBoxForDate(String date) async {
    return await Hive.openBox<StudyRecord>(date);
  }

  Future<void> addStudyRecord(StudyRecord studyRecord) async {
    final today = formattedToday;
    var box = await _getBoxForDate(today);
    await box.add(studyRecord);
  }

  Future<Map<String, List<StudyRecord>>> getStudyRecord() async {
    Map<String, List<StudyRecord>> studyRecordMap = {};
    final today = formattedToday;
    var box = await _getBoxForDate(today);

    studyRecordMap[today] = box.values.toList();

    return studyRecordMap;
  }

  Future<Map<String, List<StudyRecord>>> getStudyRecordByDate(
      String date) async {
    Map<String, List<StudyRecord>> studyRecordMap = {};
    var box = await _getBoxForDate(date);

    studyRecordMap[date] = box.values.toList();

    return studyRecordMap;
  }

  Future<void> updateStudyRecord(StudyRecord updatedStudyRecord) async {
    final today = formattedToday;

    var box = await _getBoxForDate(today);
    var studyRecords = box.values.toList();

    final lastIndex = studyRecords.length - 1;

    if (lastIndex >= 0) {
      final old = studyRecords[lastIndex];

      final newStudyRecord = StudyRecord(
        title: old.title,
        color: old.color,
        order: old.order,
        startAt: old.startAt,
        endAt: updatedStudyRecord.endAt,
        elapsedTime: updatedStudyRecord.elapsedTime,
        breakTime: updatedStudyRecord.breakTime,
      );

      await box.putAt(lastIndex, newStudyRecord);
    }
  }

  Future<void> deleteStudyRecord() async {
    final today = formattedToday;

    var box = await _getBoxForDate(today);
    var studyRecords = box.values.toList();

    if (studyRecords.isNotEmpty) {
      final lastIndex = studyRecords.length - 1;
      await box.deleteAt(lastIndex);
    }
  }

  Future<void> closeAllBoxes() async {
    await Hive.close();
  }
}
