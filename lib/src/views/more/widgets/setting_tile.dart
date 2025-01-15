import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingTile extends StatelessWidget {
  const SettingTile(
      {super.key,
      required this.title,
      this.selected,
      this.onTap,
      this.leading});

  final String title;
  final Widget? leading;
  final Widget? selected;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          selected ?? Text(''),
          SizedBox(width: 16.w),
          Icon(
            Icons.arrow_forward_ios,
            size: iconSize,
            color: Colors.grey[700],
          )
        ],
      ),
    );
  }

  double get fontSize => 12.sp;
  double get iconSize => 16.w;
}
