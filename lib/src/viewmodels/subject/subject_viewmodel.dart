import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/subject/subject.dart';
import '../../repositories/subject/subject_repository.dart';

part 'subject_viewmodel.g.dart';

@riverpod
class SubjectViewModel extends _$SubjectViewModel {
  late final SubjectRepository repository;

  @override
  Future<List<Subject>> build() async {
    repository = ref.watch(subjectRepositoryProvider);
    return await repository.getAllSubjects();
  }

  Future<void> getAllSubjects() async {
    state = await AsyncValue.guard(() => repository.getAllSubjects());
  }

  Future<void> addSubject(Subject subject) async {
    state = await AsyncValue.guard(() async {
      await repository.addSubject(subject);
      return repository.getAllSubjects();
    });
  }

  Future<void> updateSubject(Subject subject) async {
    state = await AsyncValue.guard(() async {
      await repository.updateSubject(subject);
      return repository.getAllSubjects();
    });
  }

  Future<void> deleteSubject(String subjectId) async {
    state = await AsyncValue.guard(() async {
      await repository.deleteSubject(subjectId);
      return repository.getAllSubjects();
    });
  }
}
