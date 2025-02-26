import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../models/subject/subject.dart';

class SubjectRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get _userId => FirebaseAuth.instance.currentUser!.uid;

  DocumentReference get _userSubjectsDoc =>
      _firestore.collection('subjects').doc(_userId);

  Future<void> addSubject(Subject subject) async {
    String subjectId = _userSubjectsDoc.collection('subject').doc().id;
    await _userSubjectsDoc.set({
      subjectId: subject.toJson(),
    }, SetOptions(merge: true));
  }

  Future<List<Subject>> getAllSubjects() async {
    var snapshot = await _userSubjectsDoc.get();
    if (!snapshot.exists) return [];

    var data = snapshot.data() as Map<String, dynamic>;
    return data.entries.map((e) {
      var subject = Subject.fromJson(e.value as Map<String, dynamic>);
      return subject.copyWith(subjectId: e.key);
    }).toList();
  }

  Future<void> updateSubject(Subject updatedSubject) async {
    if (updatedSubject.subjectId == null) {
      throw Exception('Subject ID is null');
    }
    await _userSubjectsDoc.update({
      updatedSubject.subjectId!: updatedSubject.toJson(),
    });
  }

  Future<void> deleteSubject(String subjectId) async {
    await _userSubjectsDoc.update({
      subjectId: FieldValue.delete(),
    });
  }
}
