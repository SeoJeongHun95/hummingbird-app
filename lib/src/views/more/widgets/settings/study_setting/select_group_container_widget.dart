import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/const/study_group.dart';
import '../../../../../../core/enum/mxnRate.dart';
import '../../../../../../core/widgets/mxnContainer.dart';
import '../../../../../viewmodels/study_setting/study_setting_view_model.dart';
import '../setting_tile_widget.dart';

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
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => studySettingViewModel.updateStudySetting(
                  updatedGroup: groups[index]),
              child: SettingTileWidget(
                title: groups[index],
                trailing: studySetting.group == groups[index]
                    ? Icon(Icons.check)
                    : Text(''),
              ),
            );
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: groups.length,
        ),
      ),
    );
  }

  List<String> get groups => StudyGroup.studyGroup[0]!;
}
