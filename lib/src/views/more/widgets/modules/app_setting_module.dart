import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hummingbird/core/enum/mxnRate.dart';
import 'package:hummingbird/src/views/more/widgets/setting_container.dart';
import 'package:hummingbird/src/views/more/widgets/setting_tile_with_seg.dart';

import '../../../../../core/enum/font_size.dart';
import '../setting_tile.dart';

class AppSettingModule extends ConsumerStatefulWidget {
  const AppSettingModule({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AppSettingModuleState();
}

class _AppSettingModuleState extends ConsumerState<AppSettingModule> {
  FontSize selectedFontSize = FontSize.MEDIUM;

  final List<ButtonSegment<FontSize>> _segments = [
    ButtonSegment(value: FontSize.SMALL, label: Text('소')),
    ButtonSegment(value: FontSize.MEDIUM, label: Text('중')),
    ButtonSegment(value: FontSize.LARGE, label: Text('대')),
  ];

  void selectFontSize(Set<FontSize> newSelection) {
    setState(() {
      selectedFontSize = newSelection.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SettingContainer(settingTiles: settingTiles, rate: MxNRate.TWOBYONE);
  }

  List<Widget> get settingTiles {
    return [
      SettingTile(title: '테마'),
      SettingTileWithSeg<FontSize>(
        title: '글자 크기',
        selected: selectedFontSize,
        segments: _segments,
        selectButton: selectFontSize,
      ),
      SettingTile(
        title: '언어',
        selected: Text(
          '한국어',
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[700],
          ),
        ),
      ),
    ];
  }
}
