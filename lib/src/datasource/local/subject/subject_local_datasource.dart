import 'package:hive/hive.dart';

import '../../../models/subject/subject.dart';

class SubjectDataSource {
  SubjectDataSource(this._box);

  final Box<Subject> _box;

  Future<void> addSubject(Subject subject) async {
    await _box.add(subject);
  }

  Future<List<Subject>> getAllSubjects() async {
    return _box.values.toList();
  }

  Future<void> updateSubject(int index, Subject updatedSubject) async {
    if (index >= 0 && index < _box.length) {
      await _box.putAt(index, updatedSubject);
    } else {
      throw Exception('Invalid index $index.');
    }
  }

  Future<void> deleteSubject(int index) async {
    if (index >= 0 && index < _box.length) {
      await _box.deleteAt(index);
    } else {
      throw Exception('Invalid index $index.');
    }
  }
}
