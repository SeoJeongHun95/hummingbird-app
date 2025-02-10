import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../viewmodels/app_setting/app_setting_view_model.dart';

class AutoFocusSwitchWidget extends ConsumerWidget {
  const AutoFocusSwitchWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAutoFocuse = ref.watch(appSettingViewModelProvider).autoFocusMode;
    final appSettingNotifer = ref.read(appSettingViewModelProvider.notifier);

    return SwitchListTile.adaptive(
      dense: true,
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity(vertical: -4),
      value: isAutoFocuse,
      onChanged: (value) {
        appSettingNotifer.updateAppSetting(updatedAutoFocusMode: value);
      },
      title: Text(
        "자동 집중모드",
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
