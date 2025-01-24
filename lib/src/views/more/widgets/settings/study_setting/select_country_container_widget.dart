import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/enum/mxnRate.dart';
import '../../../../../../core/widgets/mxnContainer.dart';
import '../setting_tile_widget.dart';

class SelectCountryContainerWidget extends ConsumerWidget {
  const SelectCountryContainerWidget({super.key});

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
              title: '대한민국',
              trailing: Icon(Icons.check),
            ),
            const Divider(),
            Gap(36.w),
            Text(
              '향후 추가할 계획입니다',
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
