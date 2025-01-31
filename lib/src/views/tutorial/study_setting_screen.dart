import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../viewmodels/study_setting/study_setting_view_model.dart';
import '../../viewmodels/user_setting/user_setting_view_model.dart';
import 'widgets/page_transition_button_widget.dart';
import 'widgets/study_setting/set_study_setting_widget.dart';

class StudySettingScreen extends ConsumerStatefulWidget {
  const StudySettingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StudySettingScreenState();
}

class _StudySettingScreenState extends ConsumerState<StudySettingScreen> {
  late int goalDuration;
  String? selectedGroup;

  @override
  void initState() {
    super.initState();
    goalDuration = ref.read(studySettingViewModelProvider).goalDuration;
  }

  void selectGoalDuration(int duration) {
    setState(() {
      goalDuration = duration;
    });
  }

  void selectGroup(String group) {
    setState(() {
      selectedGroup = group;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SetStudySettingWidget(
              goalDuration: goalDuration,
              selectedGroup: selectedGroup,
              selectGoalDuration: selectGoalDuration,
              selectGroup: selectGroup,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PageTransitionButtonWidget(
                  title: tr('StudySettingScreen.previous'),
                  backgroundColor: Colors.white,
                  foregroudColor: Theme.of(context).colorScheme.primary,
                  changePage: () {
                    context.pop();
                  },
                ),
                PageTransitionButtonWidget(
                  title: tr('StudySettingScreen.complete'),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroudColor: Colors.white,
                  changePage: () async {
                    ref
                        .read(studySettingViewModelProvider.notifier)
                        .updateStudySetting(
                            updatedGoalDuration: goalDuration,
                            updatedGroup: selectedGroup);
                    await ref
                        .read(userSettingViewModelProvider.notifier)
                        .updateUserSetting();
                    if (context.mounted) {
                      context.go('/');
                    }
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
