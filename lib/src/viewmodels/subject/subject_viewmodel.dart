import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/subject/subject.dart';
import '../../providers/network_status/network_state_provider.dart';
import '../../providers/subject/subject_repository_provider.dart';
import '../../repositories/subject/subject_repository.dart';
import '../user_setting/user_setting_view_model.dart';

part 'subject_viewmodel.g.dart';

@riverpod
class SubjectViewModel extends _$SubjectViewModel {
  late SubjectRepository repository;

  @override
  Future<List<Subject>> build() async {
    final userId = ref.read(userSettingViewModelProvider).userId;
    if (userId == null) {
      return [];
    }
    repository = ref.watch(subjectRepositoryProvider);
    final isConnected = await ref.watch(networkStateProvider.future);
    final subjects = await repository.getAllSubjects(userId, isConnected);
    return subjects;
  }

  Future<void> getAllSubjects(bool isConnected) async {
    final userId = ref.read(userSettingViewModelProvider).userId;
    if (userId == null) {
      return;
    }
    state = await AsyncValue.guard(() async {
      return await repository.getAllSubjects(userId, isConnected);
    });
  }

  Future<void> addSubject(Subject subject) async {
    final userId = ref.read(userSettingViewModelProvider).userId;
    if (userId == null) {
      return;
    }
    final bool isConnected = await ref.read(networkStateProvider.future);
    state = await AsyncValue.guard(() async {
      return await repository.addSubject(userId, subject, isConnected);
    });
  }

  Future<void> updateSubject(int index, Subject subject) async {
    final userId = ref.read(userSettingViewModelProvider).userId;
    if (userId == null) {
      return;
    }
    state = await AsyncValue.guard(() async {
      final bool isConnected = await ref.read(networkStateProvider.future);
      await repository.updateSubject(index, subject, isConnected, userId);

      final currentSubjects = state.value ?? [];
      currentSubjects[index] = subject;

      return currentSubjects;
    });
  }

  Future<void> deleteSubject(String subjectId, int index) async {
    state = await AsyncValue.guard(() async {
      await repository.deleteSubject(subjectId, index);

      final currentSubjects = state.value ?? [];
      currentSubjects.removeAt(index);

      return currentSubjects;
    });
  }
}
