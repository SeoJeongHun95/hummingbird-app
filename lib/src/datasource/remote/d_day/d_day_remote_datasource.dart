import 'dart:developer';

import 'package:StudyDuck/src/models/d_day/d_day.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DDayRemoteDatasource {
  final CollectionReference _dDayCollection =
      FirebaseFirestore.instance.collection('dDay');

  Future<String> addDDay(DDay dDay) async {
    var docRef = await _dDayCollection.add(dDay.toJson());
    await docRef.update({'id': docRef.id});

    return docRef.id;
  }

  Future<List<DDay>> getAllDDay() async {
    var snapshot = await _dDayCollection.get();

    try {
      final dDayList = snapshot.docs
          .map((doc) => DDay.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return dDayList;
    } catch (e) {
      log(e.toString());
      return <DDay>[];
    }
  }

  Future<void> updateDDay(DDay updatedDDay) async {
    if (updatedDDay.ddayId == null) {
      throw Exception('DDay Id is null');
    }
    await _dDayCollection.doc(updatedDDay.ddayId).update(updatedDDay.toJson());
  }

  Future<void> deleteDDay(String dDayId) async {
    await _dDayCollection.doc(dDayId).delete();
  }
}
