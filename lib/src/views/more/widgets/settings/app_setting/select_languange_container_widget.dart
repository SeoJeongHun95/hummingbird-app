import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/enum/mxnRate.dart';
import '../../../../../../core/widgets/mxnContainer.dart';
import '../setting_tile_widget.dart';

class SelectLanguangeContainerWidget extends ConsumerWidget {
  const SelectLanguangeContainerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MxNcontainer(
      MxN_rate: MxNRate.TWOBYONE,
      MxN_child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          children: [
            SettingTileWidget(
              title: tr('SelectLanguageContainerWidget.Korean'), // 로컬라이징된 텍스트
              trailing: Icon(Icons.check),
            ),
            const Divider(),
            Gap(36.w),
            Text(
              tr('SelectLanguageContainerWidget.FuturePlan'), // 로컬라이징된 텍스트
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
