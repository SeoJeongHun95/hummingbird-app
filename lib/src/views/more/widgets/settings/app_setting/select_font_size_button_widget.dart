import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/enum/font_size.dart';
import '../../../../../viewmodels/app_setting/app_setting_view_model.dart';
import '../setting_tile_with_seg_widget.dart';

class SelectFontSizeButtonWidget extends ConsumerStatefulWidget {
  const SelectFontSizeButtonWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectFontSizeWidgetState();
}

class _SelectFontSizeWidgetState
    extends ConsumerState<SelectFontSizeButtonWidget> {
  FontSize selectedFontSize = FontSize.MEDIUM;

  final List<ButtonSegment<FontSize>> _segments = [
    ButtonSegment(
        value: FontSize.SMALL,
        label: Text(tr('SelectFontSizeButtonWidget.Small'))),
    ButtonSegment(
        value: FontSize.MEDIUM,
        label: Text(tr('SelectFontSizeButtonWidget.Medium'))),
    ButtonSegment(
        value: FontSize.LARGE,
        label: Text(tr('SelectFontSizeButtonWidget.Large'))),
  ];

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
  Widget build(BuildContext context) {
    return SettingTileWithSegWidget<FontSize>(
      title: tr("SelectFontSizeButtonWidget.FontSize"),
      selected: selectedFontSize,
      segments: _segments,
      selectButton: selectFontSize,
    );
  }
}
