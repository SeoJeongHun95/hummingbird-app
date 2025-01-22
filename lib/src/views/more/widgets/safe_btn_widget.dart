import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SafeBtnWidget extends StatelessWidget {
  const SafeBtnWidget({
    super.key,
    required this.title,
    required this.isValid,
    required this.backgroundColor,
    required this.foregroudColor,
    required this.safeProfile,
  });

  final String title;
  final bool isValid;
  final Color backgroundColor;
  final Color foregroudColor;
  final void Function() safeProfile;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: safeProfile,
      child: Container(
        width: 320.w + 16,
        height: 50.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isValid ? backgroundColor : grey,
          border: Border.all(
            color: isValid ? Theme.of(context).colorScheme.primary : grey,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: foregroudColor,
            ),
          ),
        ),
      ),
    );
  }

  Color get grey => Colors.grey;
}
