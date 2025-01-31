import 'package:StudyDuck/src/viewmodels/study_setting/study_setting_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../setting_tile_widget.dart';

class SelectGroupButtonWidget extends ConsumerWidget {
  const SelectGroupButtonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPath = GoRouterState.of(context).uri.path;
    final studySetting = ref.watch(studySettingViewModelProvider);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.go('$currentPath/group'),
      child: SettingTileWidget(
        title: '그룹',
        selected: Text(
          studySetting.group ?? '그룹을 선택하세요',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
              ),
        ),
      ),
    );
  }
}
