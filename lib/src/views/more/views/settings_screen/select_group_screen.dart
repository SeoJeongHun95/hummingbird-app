import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/const/study_group.dart';
import '../../../../../core/enum/mxnRate.dart';
import '../../../../../core/widgets/mxnContainer.dart';
import '../../../../viewmodels/study_setting/study_setting_view_model.dart';
import '../../widgets/settings/setting_tile_widget.dart';

class SelectGroupScreen extends ConsumerWidget {
  const SelectGroupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studySetting = ref.watch(studySettingViewModelProvider);
    final studySettingViewModel =
        ref.read(studySettingViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            onPressed: () => context.pop(),
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),
        title: Text('그룹'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              MxNcontainer(
                MxN_rate: MxNRate.TWOBYTWO,
                MxN_child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => studySettingViewModel.updateStudySetting(
                            updatedGroup: groups[index]),
                        child: SettingTileWidget(
                          title: groups[index],
                          trailing: studySetting.group == groups[index]
                              ? Icon(
                                  Icons.check,
                                  size: 16.w,
                                )
                              : Text(''),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: groups.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> get groups => StudyGroup.studyGroup[0]!;
}
