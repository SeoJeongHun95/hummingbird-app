import 'package:hive/hive.dart';

import '../../../models/study_record/subject/subject.dart';

class SubjectDataSource {
  SubjectDataSource(this._box);

  final Box<Subject> _box;

  // 과목 추가
  Future<void> addSubject(Subject subject) async {
    await _box.add(subject);
  }

  // 모든 과목 가져오기
  Future<List<Subject>> getAllSubjects() async {
    return _box.values.toList();
  }

  // 과목 업데이트
  Future<void> updateSubject(int index, Subject updatedSubject) async {
    if (index >= 0 && index < _box.length) {
      await _box.putAt(index, updatedSubject);
    } else {
      throw Exception('Invalid index $index.');
    }
  }

  // 과목 삭제
  Future<void> deleteSubject(int index) async {
    if (index >= 0 && index < _box.length) {
      await _box.deleteAt(index);
    } else {
      throw Exception('Invalid index $index.');
    }
  }
}
