import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/enum/mxnRate.dart';
import '../../../../../core/widgets/mxnContainer.dart';

class SaveButtonWidget extends StatelessWidget {
  const SaveButtonWidget({
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: safeProfile,
        child: SizedBox(
          width: double.maxFinite,
          height: 60.h,
          child: MxNcontainer(
            MxN_rate: MxNRate.ONEBYHALF,
            MxN_child: Container(
              decoration: BoxDecoration(
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
          ),
        ),
      ),
    );
  }

  Color get grey => Colors.grey;
}
