import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../setting_tile_widget.dart';

class SelectThemeButtonWidget extends ConsumerWidget {
  const SelectThemeButtonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SettingTileWidget(
      title: tr('SelectThemeButtonWidget.ThemeColor'),
      selected: Text(
        tr('SelectThemeButtonWidget.FuturePlan'),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[700],
            ),
      ),
    );
  }
}
