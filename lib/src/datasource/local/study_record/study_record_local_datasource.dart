import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';

import '../../../models/study_record/study_record.dart';

class StudyRecordDataSource {
  StudyRecordDataSource(this._box);

  final Box<List<StudyRecord>> _box;

  Future<void> addStudyRecord(String date, StudyRecord studyRecord) async {
    final existingData = await getStudyRecordsByDate(date);
    existingData.add(studyRecord);

    log("$existingData");

    await _box.put(date, existingData);
  }

  Future<List<StudyRecord>> getStudyRecordsByDate(String date) async {
    try {
      final existingData =
          _box.get(date, defaultValue: <StudyRecord>[])?.cast<StudyRecord>() ??
              [];
      return existingData;
    } catch (e, stackTrace) {
      log("Error reading records for $date: $e", stackTrace: stackTrace);
      return [];
    }
  }

  Future<void> updateStudyRecord(
      String date, StudyRecord updatedStudyRecord) async {
    final existingData = await getStudyRecordsByDate(date);

    if (existingData.isNotEmpty) {
      final lastIndex = existingData.length - 1;
      final old = existingData[lastIndex];
      final newStudyRecord = StudyRecord(
        subject: old.subject,
        startAt: old.startAt,
        endAt: updatedStudyRecord.endAt,
        elapsedTime: updatedStudyRecord.elapsedTime,
        breakTime: updatedStudyRecord.breakTime,
      );
      existingData[lastIndex] = newStudyRecord;

      log("Updated record: $newStudyRecord");
      log("All records: $existingData");

      await _box.put(date, existingData);
    } else {
      log("No records found for date: $date");
      throw Exception('No study records to update.');
    }
  }
}
