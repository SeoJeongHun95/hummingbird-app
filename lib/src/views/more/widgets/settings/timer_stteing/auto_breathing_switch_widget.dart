import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../viewmodels/app_setting/app_setting_view_model.dart';

class AutoBreathingSwitchWidget extends ConsumerWidget {
  const AutoBreathingSwitchWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAutoBreathing =
        ref.watch(appSettingViewModelProvider).autoBreathingExercise;
    final appSettingNotifer = ref.read(appSettingViewModelProvider.notifier);

    return SwitchListTile.adaptive(
      dense: true,
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity(vertical: -4),
      value: isAutoBreathing,
      onChanged: (value) {
        appSettingNotifer.updateAppSetting(updatedAutoBreathingExercise: value);
      },
      title: Text(
        tr("TimerSetting.AutoBreathingExercise"),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
