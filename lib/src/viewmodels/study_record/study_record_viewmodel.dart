import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/study_record/study_record.dart';
import '../../repositories/study_record/study_record_repository.dart';

part 'study_record_viewmodel.g.dart';

@riverpod
class StudyRecordViewModel extends _$StudyRecordViewModel {
  late final StudyRecordRepository repository;

  @override
  AsyncValue<List<StudyRecord>> build() {
    repository = ref.watch(studyRecordRepositoryProvider);
    state = const AsyncValue.loading();
    return state;
  }

  // 날짜별로 학습 기록을 불러오는 메서드
  Future<void> loadStudyRecordsByDate(String date) async {
    state = await AsyncValue.guard(() async {
      return await repository.getStudyRecordsByDate(date);
    });
  }

  // 학습 기록을 추가하는 메서드
  Future<void> addStudyRecord(String date, StudyRecord studyRecord) async {
    await repository.addStudyRecord(date, studyRecord);
    loadStudyRecordsByDate(date); // 추가 후 해당 날짜의 학습 기록을 다시 로드
  }

  // 학습 기록을 업데이트하는 메서드
  Future<void> updateStudyRecord(String date, StudyRecord studyRecord) async {
    await repository.updateStudyRecord(date, studyRecord);
    loadStudyRecordsByDate(date); // 업데이트 후 해당 날짜의 학습 기록을 다시 로드
  }
}
