import 'package:hive_flutter/hive_flutter.dart';

import '../../../models/study_record/study_record.dart';

class StudyRecordDataSource {
  StudyRecordDataSource(this._box);

  final Box<List<StudyRecord>> _box;

  Future<void> addStudyRecord(String date, StudyRecord studyRecord) async {
    final existingData = await getStudyRecordsByDate(date);
    existingData.add(studyRecord);

    await _box.put(date, existingData);
  }

  Future<List<StudyRecord>> getStudyRecordsByDate(String date) async {
    try {
      final existingData =
          _box.get(date, defaultValue: <StudyRecord>[])?.cast<StudyRecord>() ??
              [];
      return existingData;
    } catch (e) {
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

      await _box.put(date, existingData);
    } else {
      throw Exception('No study records to update.');
    }
  }

  Future<void> deleteStudyRecord(String date) async {
    final existingData = await getStudyRecordsByDate(date);

    if (existingData.isNotEmpty) {
      existingData.removeLast();
      await _box.put(date, existingData);
    } else {
      throw Exception('No study records to delete.');
    }
  }
}
