import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PageTransitionButtonWidget extends StatelessWidget {
  const PageTransitionButtonWidget({
    super.key,
    required this.title,
    required this.backgroundColor,
    required this.foregroudColor,
    required this.changePage,
  });

  final String title;
  final Color backgroundColor;
  final Color foregroudColor;
  final void Function() changePage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: changePage,
      child: Container(
        width: 100.w,
        height: 50.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: backgroundColor,
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
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
