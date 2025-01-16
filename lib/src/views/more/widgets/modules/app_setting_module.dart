import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hummingbird/core/enum/mxnRate.dart';

import '../../../../../core/enum/font_size.dart';
import '../../../../viewmodels/app_setting/app_setting_view_model.dart';
import '../settings/setting_container.dart';
import '../settings/setting_tile.dart';
import '../settings/setting_tile_with_seg.dart';

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
    return SettingContainer(
        settingTiles: getSettingTiles(currentRouterPath),
        rate: MxNRate.TWOBYONE);
  }

  List<Widget> getSettingTiles(String currentRouterPath) {
    return [
      SettingTile(title: '테마'),
      SettingTileWithSeg<FontSize>(
        title: '글자 크기',
        selected: selectedFontSize,
        segments: _segments,
        selectButton: selectFontSize,
      ),
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => context.go('$currentRouterPath/language'),
        child: SettingTile(
          title: '언어',
          selected: Text(
            '한국어',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[700],
            ),
          ),
        ),
      ),
      // SettingTile(
      //   title: '언어',
      //   selected: DropdownButton<Locale>(
      //     value: context.locale, // 현재 언어 설정
      //     onChanged: (Locale? newLocale) {
      //       if (newLocale != null) {
      //         setState(() {
      //           context.setLocale(newLocale);
      //         });
      //       }
      //     },

      //todo : 다국어 지원을 위한 설정, 배포전 수정 필요
      // items: [
      //   DropdownMenuItem(
      //     value: const Locale('ko', 'KR'),
      //     child: Text('한국어'),
      //   ),
      // ],

      //     items: [
      //       DropdownMenuItem(
      //         value: const Locale('ko', 'KR'),
      //         child: Text('한국어'),
      //       ),
      //       DropdownMenuItem(
      //         value: const Locale('en', 'US'),
      //         child: Text('English'),
      //       ),
      //       DropdownMenuItem(
      //         value: const Locale('ja', 'JP'),
      //         child: Text('日本語'),
      //       ),
      //       DropdownMenuItem(
      //         value: const Locale('zh', 'CN'),
      //         child: Text('中文'),
      //       ),
      //       DropdownMenuItem(
      //         value: const Locale('vi', 'VN'),
      //         child: Text('Tiếng Việt'),
      //       ),
      //       DropdownMenuItem(
      //         value: const Locale('th', 'TH'),
      //         child: Text('ไทย'),
      //       ),
      //     ],
      //   ),
      // ),
    ];
  }
}
