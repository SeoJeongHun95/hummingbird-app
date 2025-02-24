import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../models/study_record/study_record.dart';

class StudyRecordDataSource {
  StudyRecordDataSource();

  void addStudyRecord(StudyRecord studyRecord) async {
    String monthKey = DateFormat('yyyy-MM').format(DateTime.now());
    String userId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('studyRecords')
        .doc(userId)
        .collection(monthKey)
        .add(studyRecord.toJson());
  }

  Future<List<StudyRecord>> getMonthlyStudyRecords(String yearMonth) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    var snapshot = await FirebaseFirestore.instance
        .collection('studyRecords')
        .doc(userId)
        .collection(yearMonth)
        .get();

    return snapshot.docs
        .map((doc) => StudyRecord.fromJson(doc.data()))
        .toList();
  }
}
