import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/subject/subject.dart';

class SubjectRemoteDataSource {
  final CollectionReference _subjectCollection =
      FirebaseFirestore.instance.collection('subjects');

  Future<String> addSubject(Subject subject) async {
    var docRef = await _subjectCollection.add(subject.toJson());
    await docRef.update({'id': docRef.id});
    return docRef.id;
  }

  Future<List<Subject>> getAllSubjects() async {
    var snapshot = await _subjectCollection.get();
    return snapshot.docs
        .map((doc) => Subject.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateSubject(Subject updatedSubject) async {
    if (updatedSubject.subjectId == null) {
      throw Exception('Subject ID is null');
    }
    await _subjectCollection
        .doc(updatedSubject.subjectId)
        .update(updatedSubject.toJson());
  }

  Future<void> deleteSubject(String subjectId) async {
    await _subjectCollection.doc(subjectId).delete();
  }
}
