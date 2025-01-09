import 'package:hive_flutter/hive_flutter.dart';

import '../../../models/study_record/study_record.dart';

class StudyRecordDataSource {
  StudyRecordDataSource(this._box);

  final Box<StudyRecord> _box;

  Future<void> addStudyRecord(StudyRecord studyRecord) async {
    await _box.add(studyRecord);
  }

  Future<List<StudyRecord>> getAllStudyRecords() async {
    return _box.values.toList();
  }
}
