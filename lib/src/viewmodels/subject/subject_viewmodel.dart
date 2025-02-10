import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/subject/subject.dart';
import '../../providers/subject/subject_repository_provider.dart';
import '../../repositories/subject/subject_repository.dart';

part 'subject_viewmodel.g.dart';

@riverpod
class SubjectViewModel extends _$SubjectViewModel {
  late SubjectRepository repository;

  @override
  Future<List<Subject>> build() async {
    repository = ref.watch(subjectRepositoryProvider);
    final subjects = await repository.getAllSubjects();

    return subjects;
  }

  Future<void> getAllSubjects(bool isConnected) async {
    state = await AsyncValue.guard(() async {
      return await repository.getAllSubjects();
    });
  }

  Future<void> addSubject(Subject subject) async {
    state = await AsyncValue.guard(() async {
      return await repository.addSubject(subject);
    });
  }

  Future<void> updateSubject(int index, Subject subject) async {
    state = await AsyncValue.guard(() async {
      await repository.updateSubject(index, subject);

      final currentSubjects = state.value ?? [];
      currentSubjects[index] = subject;

      return currentSubjects;
    });
  }

  Future<void> deleteSubject(int index) async {
    state = await AsyncValue.guard(() async {
      await repository.deleteSubject(index);

      final currentSubjects = state.value ?? [];
      currentSubjects.removeAt(index);

      return currentSubjects;
    });
  }
}
