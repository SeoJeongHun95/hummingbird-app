import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/study_record/subject/subject.dart';
import '../../providers/subject/subject_repository_provider.dart';
import '../../repositories/subject/subject_repository.dart';

part 'subject_viewmodel.g.dart';

@riverpod
class SubjectViewModel extends _$SubjectViewModel {
  late final SubjectRepository repository;

  @override
  AsyncValue<List<Subject>> build() {
    repository = ref.watch(subjectRepositoryProvider);
    loadSubjects();
    return const AsyncValue.loading();
  }

  // 모든 과목을 로드
  Future<void> loadSubjects() async {
    state = await AsyncValue.guard(() async {
      return await repository.getAllSubjects();
    });
  }

  // 과목 추가
  Future<void> addSubject(Subject subject) async {
    state = await AsyncValue.guard(() async {
      await repository.addSubject(subject);

      final currentSubjects = state.value ?? [];
      currentSubjects.add(subject);

      return currentSubjects;
    });
  }

  // 과목 업데이트
  Future<void> updateSubject(int index, Subject subject) async {
    state = await AsyncValue.guard(() async {
      await repository.updateSubject(index, subject);

      final currentSubjects = state.value ?? [];
      currentSubjects[index] = subject;

      return currentSubjects;
    });
  }

  // 과목 삭제
  Future<void> deleteSubject(int index) async {
    state = await AsyncValue.guard(() async {
      await repository.deleteSubject(index);

      final currentSubjects = state.value ?? [];
      currentSubjects.removeAt(index);

      return currentSubjects;
    });
  }
}
