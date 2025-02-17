import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../models/study_record/study_record.dart';

class StudyRecordDataSource {
  StudyRecordDataSource();

  void addStudyRecord(StudyRecord studyRecord) async {
    String monthKey = DateFormat('yyyy-MM').format(DateTime.now());

    await FirebaseFirestore.instance
        .collection('studyRecords')
        .doc(monthKey)
        .collection('records')
        .add(studyRecord.toJson());
  }

  Future<List<StudyRecord>> getMonthlyStudyRecords(String yearMonth) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('studyRecords')
        .doc(yearMonth)
        .collection('records')
        .get();

    return snapshot.docs
        .map((doc) => StudyRecord.fromJson(doc.data()))
        .toList();
  }
}
