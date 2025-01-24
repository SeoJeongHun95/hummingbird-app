import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../setting_tile_widget.dart';

class SelectThemeButtonWidget extends ConsumerWidget {
  const SelectThemeButtonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SettingTileWidget(
      title: '테마 색상',
      selected: Text(
        '향후 추가할 계획입니다',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[700],
            ),
      ),
    );
  }
}
