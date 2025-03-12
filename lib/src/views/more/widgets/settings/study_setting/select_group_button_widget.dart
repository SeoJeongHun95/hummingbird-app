import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../viewmodels/study_setting/study_setting_view_model.dart';
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
        title: tr('SelectGroupButtonWidget.Group'),
        selected: Text(
          studySetting.group ?? tr('SelectGroupButtonWidget.SelectGroupPrompt'),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
              ),
        ),
      ),
    );
  }
}
