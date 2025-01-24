import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/widgets/circle_color_container.dart';
import '../../../../models/d_day/d_day.dart';
import '../../../../viewmodels/d_day/d_day_view_model.dart';
import 'color_picker_dialog.dart';

class AddDDayDialog extends StatefulWidget {
  const AddDDayDialog({super.key, required this.viewModel});

  final DDayViewModel viewModel;

  @override
  State<AddDDayDialog> createState() => _AddDDayDialogState();
}

class _AddDDayDialogState extends State<AddDDayDialog> {
  final _textController = TextEditingController();
  DateTime? goalDate;
  TimeOfDay? goalTime;
  String color = '227C9D';

  Color tilteValidationColor = Colors.black;
  Color dateValidationColor = Colors.black;
  Color timeValidationColor = Colors.black;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(tr("DDayDialog.Add")),
      content: SizedBox(
        height: 250.h,
        child: Column(
          children: [
            TextField(
              controller: _textController,
              style: TextStyle(fontSize: 15.sp),
              maxLength: 30,
              decoration: InputDecoration(
                hintText: tr("DDayDialog.EnterGoalTitle"),
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
                final selectedDate = await _pickNewGoalDate(context);
                if (selectedDate != null) {
                  setState(() {
                    goalDate = selectedDate;
                    dateValidationColor = Colors.black;
                  });
                }
              },
              title: Text(
                tr("DDayDialog.GoalDate"),
                style: TextStyle(fontSize: 15.sp),
              ),
              trailing: Text(
                goalDate == null
                    ? tr("DDayDialog.SelectDate")
                    : '${goalDate!.year}-${goalDate!.month}-${goalDate!.day}',
                style: TextStyle(fontSize: 13.sp, color: dateValidationColor),
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
                    timeValidationColor = Colors.black;
                  });
                }
              },
              title: Text(
                tr("DDayDialog.GoalTime"),
                style: TextStyle(fontSize: 15.sp),
              ),
              trailing: Text(
                goalTime == null
                    ? tr("DDayDialog.SelectTime")
                    : '${(goalTime!.hour).toString().padLeft(2, '0')}:${goalTime!.minute.toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 13.sp, color: timeValidationColor),
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
                tr("DDayDialog.Color"),
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
          child: Text(tr("DDayDialog.Cancel")),
        ),
        TextButton(
          onPressed: () {
            if (_textController.text.isNotEmpty &&
                goalDate != null &&
                goalTime != null) {
              final goalDateTimeByUtc = DateTime(
                goalDate!.year,
                goalDate!.month,
                goalDate!.day,
                goalTime!.hour,
                goalTime!.minute,
              ).toUtc();
              final newDDay = DDay(
                  title: _textController.text,
                  targetDatetime:
                      (goalDateTimeByUtc.millisecondsSinceEpoch) ~/ 1000,
                  color: color);
              widget.viewModel.addDDay(newDDay);
              Navigator.pop(context);
            } else {
              setState(() {
                tilteValidationColor = _textController.text.isNotEmpty
                    ? Colors.black
                    : Theme.of(context).colorScheme.error;
                dateValidationColor = goalDate != null
                    ? Colors.black
                    : Theme.of(context).colorScheme.error;
                timeValidationColor = goalTime != null
                    ? Colors.black
                    : Theme.of(context).colorScheme.error;
              });
            }
          },
          child: Text(tr("DDayDialog.Confirm")),
        )
      ],
    );
  }

  Future<DateTime?> _pickNewGoalDate(BuildContext context) async {
    return await showDatePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );
  }

  Future<TimeOfDay?> _pickNewGoalTime(
      BuildContext context, TimeOfDay? goalTime) async {
    return await showTimePicker(
      context: context,
      initialTime: goalTime ?? TimeOfDay(hour: TimeOfDay.now().hour, minute: 0),
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
