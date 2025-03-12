import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../models/d_day/d_day.dart';

class DDayRemoteDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get _userId => FirebaseAuth.instance.currentUser!.uid;

  DocumentReference get _userDDaysDoc =>
      _firestore.collection('dDays').doc(_userId);

  Future<void> addDDay(DDay dDay) async {
    String dDayId = _firestore.collection('dDay').doc().id;

    await _userDDaysDoc.set({
      dDayId: dDay.toJson(),
    }, SetOptions(merge: true));
  }

  Future<List<DDay>> getAllDDay() async {
    var snapshot = await _userDDaysDoc.get();
    if (!snapshot.exists) return [];

    try {
      final data = snapshot.data() as Map<String, dynamic>;

      final dDayList = data.entries.map((mapEntry) {
        final dDay = DDay.fromJson(mapEntry.value as Map<String, dynamic>);
        return dDay.copyWith(ddayId: mapEntry.key);
      }).toList();

      return dDayList;
    } catch (e) {
      return <DDay>[];
    }
  }

  Future<void> updateDDay(DDay updatedDDay) async {
    if (updatedDDay.ddayId == null) {
      throw Exception('DDay Id is null');
    }
    await _userDDaysDoc.update({updatedDDay.ddayId!: updatedDDay.toJson()});
  }

  Future<void> deleteDDay(String dDayId) async {
    await _userDDaysDoc.update({dDayId: FieldValue.delete()});
  }
}
