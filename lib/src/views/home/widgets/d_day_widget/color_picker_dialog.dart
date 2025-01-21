import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/widgets/circle_color_container.dart';
import '../../../../datasource/local/d_day_local_datasource/dummy_data.dart';

class ColorPickerDialog extends StatefulWidget {
  const ColorPickerDialog({super.key, this.oldColor});

  final String? oldColor;

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  String? selectedColor;

  @override
  void initState() {
    selectedColor = widget.oldColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Wrap(
        spacing: 10.w,
        runSpacing: 10.w,
        children: DummyData.colors.map((color) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedColor = color;
              });
            },
            child: color == selectedColor
                ? CircleColorContainer(
                    width: 30.w, color: color, isSelected: true)
                : CircleColorContainer(width: 30.w, color: color),
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("취소"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, selectedColor),
          child: Text("확인"),
        ),
      ],
    );
  }
}
