import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/const/study_group.dart';
import '../../../../../../core/enum/mxnRate.dart';
import '../../../../../../core/widgets/mxnContainer.dart';
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
          studySetting.group != null
              ? studySetting.group!.tr()
              : tr('SelectGroupButtonWidget.SelectGroupPrompt'),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
              ),
        ),
      ),
    );
  }
}

class SelectGroupContainerWidget extends ConsumerWidget {
  const SelectGroupContainerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studySetting = ref.watch(studySettingViewModelProvider);
    final studySettingViewModel =
        ref.read(studySettingViewModelProvider.notifier);
    return MxNcontainer(
      MxN_rate: MxNRate.TWOBYTWO,
      MxN_child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: ListView.separated(
          itemBuilder: (context, index) {
            final key = groups[index];
            final translatedText = key.tr();
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () =>
                  studySettingViewModel.updateStudySetting(updatedGroup: key),
              child: SettingTileWidget(
                title: translatedText,
                trailing:
                    studySetting.group == key ? Icon(Icons.check) : Text(''),
              ),
            );
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: groups.length,
        ),
      ),
    );
  }

  List<String> get groups => StudyGroup.studyGroupKeys[0]!;
}
