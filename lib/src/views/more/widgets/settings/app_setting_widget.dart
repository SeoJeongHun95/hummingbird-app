import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/enum/font_size.dart';
import '../../../../../core/enum/mxnRate.dart';
import '../../../../viewmodels/app_setting/app_setting_view_model.dart';
import 'setting_container_widget.dart';
import 'setting_tile_widget.dart';
import 'setting_tile_with_seg_widget.dart';

class AppSettingWidget extends ConsumerStatefulWidget {
  const AppSettingWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AppSettingWidgetState();
}

class _AppSettingWidgetState extends ConsumerState<AppSettingWidget> {
  FontSize selectedFontSize = FontSize.MEDIUM;

  final List<ButtonSegment<FontSize>> _segments = [
    ButtonSegment(value: FontSize.SMALL, label: Text('소')),
    ButtonSegment(value: FontSize.MEDIUM, label: Text('중')),
    ButtonSegment(value: FontSize.LARGE, label: Text('대')),
  ];

  void selectFontSize(Set<FontSize> newSelection) async {
    final updatedFontSize = switch (newSelection.first) {
      FontSize.SMALL => 2,
      FontSize.MEDIUM => 4,
      _ => 6
    };
    ref
        .read(appSettingViewModelProvider.notifier)
        .updateAppSetting(updatedFontSize: updatedFontSize);
    setState(() {
      selectedFontSize = newSelection.first;
    });
  }

  @override
  void initState() {
    super.initState();
    final currentFontSize = ref.read(appSettingViewModelProvider).fontSize;
    selectedFontSize = switch (currentFontSize) {
      2 => FontSize.SMALL,
      4 => FontSize.MEDIUM,
      _ => FontSize.LARGE,
    };
  }

  @override
  Widget build(BuildContext context) {
    final String currentRouterPath = GoRouterState.of(context).uri.path;
    return SettingContainerWidget(
        settingTiles: getSettingTiles(currentRouterPath),
        rate: MxNRate.TWOBYONE);
  }

  List<Widget> getSettingTiles(String currentRouterPath) {
    return [
      SettingTileWidget(
        title: '테마 색상',
        selected: Text(
          '향후 추가할 계획입니다',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
              ),
        ),
      ),
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => context.go('$currentRouterPath/language'),
        child: SettingTileWidget(
          title: '언어',
          selected: Text(
            '한국어',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
          ),
        ),
      ),
      SettingTileWithSegWidget<FontSize>(
        title: '글자 크기',
        selected: selectedFontSize,
        segments: _segments,
        selectButton: selectFontSize,
      ),
    ];
  }
}
