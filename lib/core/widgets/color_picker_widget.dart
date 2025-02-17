import 'package:StudyDuck/core/theme/colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../enum/mxnRate.dart';
import 'circle_color_container.dart';
import 'mxnContainer.dart';

class ColorPickerWidget extends StatefulWidget {
  final String? initialColor;
  final Function(String) onColorSelected;

  const ColorPickerWidget({
    super.key,
    this.initialColor,
    required this.onColorSelected,
  });

  @override
  State<ColorPickerWidget> createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  String? selectedColor;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.initialColor ?? AppColor.dSubColors.first;
  }

  @override
  Widget build(BuildContext context) {
    return MxNcontainer(
      MxN_rate: MxNRate.TWOBYONE,
      MxN_child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Wrap(
          spacing: 10.w,
          runSpacing: 10.w,
          children: AppColor.dSubColors.map((color) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedColor = color;
                });
                widget.onColorSelected(color);
              },
              child: color == selectedColor
                  ? CircleColorContainer(
                      width: 30.w, color: color, isSelected: true)
                  : CircleColorContainer(width: 30.w, color: color),
            );
          }).toList(),
        ),
      ),
    );
  }
}
