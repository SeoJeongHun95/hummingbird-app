import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/const/study_group.dart';
import '../../more/widgets/settings/setting_tile_widget.dart';

class SelectGroupBottomSheet extends StatefulWidget {
  const SelectGroupBottomSheet({super.key, required this.selectedGroup});

  final String? selectedGroup;

  @override
  State<SelectGroupBottomSheet> createState() => _SelectGroupBottomSheetState();
}

class _SelectGroupBottomSheetState extends State<SelectGroupBottomSheet> {
  String? selectedGroup;

  @override
  void initState() {
    selectedGroup = widget.selectedGroup;
    super.initState();
  }

  void selectGroup(String group) {
    setState(() {
      selectedGroup = group;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280.h,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            Row(
              children: [
                Text(
                  tr('SelectGroupBottomSheet.selectGroup'),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context, selectedGroup),
                  child: Text(
                    tr('SelectGroupBottomSheet.complete'),
                    style: TextStyle(
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => selectGroup(groups[index]),
                    child: SettingTileWidget(
                      title: groups[index],
                      trailing: selectedGroup == groups[index]
                          ? Icon(
                              Icons.check,
                              size: 16.w,
                            )
                          : Text(''),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: groups.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> get groups => StudyGroup.studyGroup[0]!;
}
