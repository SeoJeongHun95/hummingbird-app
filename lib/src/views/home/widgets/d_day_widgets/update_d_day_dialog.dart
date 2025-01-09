import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../models/d_day/d_day.dart';
import '../../../../viewmodels/d_day/d_day_view_model.dart';
import '../../../../../core/widgets/circle_color_container.dart';
import 'color_picker_dialog.dart';

class UpdateDDayDialog extends StatefulWidget {
  const UpdateDDayDialog(
      {super.key,
      required this.index,
      required this.goalTitle,
      required this.goalDate,
      required this.color,
      required this.viewModel});

  final int index;
  final String goalTitle;
  final int goalDate;
  final String color;
  final DDayViewModel viewModel;

  @override
  State<UpdateDDayDialog> createState() => _UpdateDDayDialogState();
}

class _UpdateDDayDialogState extends State<UpdateDDayDialog> {
  final _textController = TextEditingController();
  late DateTime goalDate;
  late TimeOfDay goalTime;
  late String color;

  Color tilteValidationColor = Colors.black;

  @override
  void initState() {
    final DateTime goalDateTimeByUtc =
        DateTime.fromMillisecondsSinceEpoch(widget.goalDate).toLocal();
    goalDate = goalDateTimeByUtc;
    goalTime = TimeOfDay.fromDateTime(goalDateTimeByUtc);
    color = widget.color;
    _textController.text = widget.goalTitle;
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('편집'),
      content: SizedBox(
        height: 250.h,
        child: Column(
          children: [
            TextField(
              controller: _textController,
              maxLength: 30,
              style: TextStyle(fontSize: 15.sp),
              decoration: InputDecoration(
                hintText: "목표 제목을 입력하시오",
                hintStyle: TextStyle(color: tilteValidationColor),
                counterText: '',
                border: InputBorder.none,
                isDense: true,
              ),
            ),
            Divider(height: 8, color: Theme.of(context).colorScheme.onSurface),
            ListTile(
              visualDensity: VisualDensity(vertical: -4),
              contentPadding: EdgeInsets.zero,
              dense: true,
              onTap: () async {
                final selectedDate =
                    await _pickNewGoalDate(context, widget.goalDate);
                if (selectedDate != null) {
                  setState(() {
                    goalDate = selectedDate;
                  });
                }
              },
              title: Text(
                '목표 날짜:',
                style: TextStyle(fontSize: 15.sp),
              ),
              trailing: Text(
                '${goalDate.year}-${goalDate.month}-${goalDate.day}',
                style: TextStyle(fontSize: 15.sp),
              ),
            ),
            Divider(height: 8, color: Theme.of(context).colorScheme.onSurface),
            ListTile(
              visualDensity: VisualDensity(vertical: -4),
              contentPadding: EdgeInsets.zero,
              dense: true,
              onTap: () async {
                final selectedTime = await _pickNewGoalTime(context, goalTime);
                if (selectedTime != null) {
                  setState(() {
                    goalTime = selectedTime;
                  });
                }
              },
              title: Text(
                '목표 시간:',
                style: TextStyle(fontSize: 15.sp),
              ),
              trailing: Text(
                '${(goalTime.hour).toString().padLeft(2, '0')}:${goalTime.minute.toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 15.sp),
              ),
            ),
            Divider(height: 8, color: Theme.of(context).colorScheme.onSurface),
            ListTile(
              visualDensity: VisualDensity(vertical: -4),
              contentPadding: EdgeInsets.zero,
              dense: true,
              onTap: () async {
                final selectedColor = await _pickColor(context, color);
                if (selectedColor != null) {
                  setState(() {
                    color = selectedColor;
                  });
                }
              },
              title: Text(
                '색상:',
                style: TextStyle(fontSize: 15.sp),
              ),
              trailing: CircleColorContainer(
                width: 20.w,
                color: color,
              ),
            ),
            Divider(height: 8, color: Theme.of(context).colorScheme.onSurface),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('취소'),
        ),
        TextButton(
          onPressed: () {
            if (_textController.text.isNotEmpty) {
              final goalDateTimeByUtc = DateTime(
                goalDate.year,
                goalDate.month,
                goalDate.day,
                goalTime.hour,
                goalTime.minute,
              ).toUtc();
              final updateDDay = DDay(
                  title: _textController.text,
                  targetDate: goalDateTimeByUtc.millisecondsSinceEpoch,
                  color: color);
              widget.viewModel.updateDDay(widget.index, updateDDay);
              Navigator.pop(context);
            } else {
              setState(() {
                tilteValidationColor = Theme.of(context).colorScheme.error;
              });
            }
          },
          child: Text('확인'),
        )
      ],
    );
  }

  Future<DateTime?> _pickNewGoalDate(
      BuildContext context, int oldGoalDate) async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.fromMillisecondsSinceEpoch(oldGoalDate).toLocal(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );
  }

  Future<TimeOfDay?> _pickNewGoalTime(
      BuildContext context, TimeOfDay goalTime) async {
    return await showTimePicker(
      context: context,
      initialTime: goalTime,
      initialEntryMode: TimePickerEntryMode.input,
    );
  }

  Future<String?> _pickColor(BuildContext context, String oldColor) async {
    return await showDialog<String>(
      context: context,
      builder: (context) {
        return ColorPickerDialog(oldColor: oldColor);
      },
    );
  }
}
