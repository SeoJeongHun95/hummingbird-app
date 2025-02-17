import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/enum/mxnRate.dart';
import '../../../../../core/theme/colors/app_color.dart';
import '../../../../../core/utils/format_date.dart';
import '../../../../../core/utils/show_snack_bar.dart';
import '../../../../../core/widgets/color_picker_widget.dart';
import '../../../../../core/widgets/mxnContainer.dart';
import '../../../../models/d_day/d_day.dart';
import '../../../../viewmodels/d_day/d_day_view_model.dart';

class DDayUpdateScreen extends ConsumerStatefulWidget {
  const DDayUpdateScreen({
    super.key,
    required this.index,
    required this.dDayId,
    required this.title,
    required this.color,
    required this.targetDatetime,
  });

  final int index;
  final String dDayId;
  final String title;
  final String color;
  final int targetDatetime;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DDayAddScreenState();
}

class _DDayAddScreenState extends ConsumerState<DDayUpdateScreen> {
  final TextEditingController _titleController = TextEditingController();

  late DateTime goalDate;
  late TimeOfDay goalTime;
  late String selectedColor;

  @override
  void initState() {
    final DateTime goalDateTimeByUtc =
        DateTime.fromMillisecondsSinceEpoch(widget.targetDatetime * 1000);
    goalDate = goalDateTimeByUtc.toLocal();
    goalTime = TimeOfDay.fromDateTime(goalDateTimeByUtc);
    selectedColor = widget.color;
    _titleController.text = widget.title;

    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dDayViewModel = ref.read(dDayViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('DDayUpdateScreen.DDayEdit')),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            tr('DDayUpdateScreen.GoalTitle'),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        MxNcontainer(
                          MxN_rate: MxNRate.TWOBYQUARTER,
                          MxN_child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _titleController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            tr('DDayUpdateScreen.GoalDate'),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final selectedDate =
                                await _pickNewGoalDate(context);

                            if (selectedDate != null) {
                              setState(() {
                                goalDate = selectedDate;
                              });
                            }
                            if (context.mounted) {
                              FocusScope.of(context).unfocus();
                            }
                          },
                          child: MxNcontainer(
                            MxN_rate: MxNRate.TWOBYQUARTER,
                            MxN_child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(formatDate(goalDate)),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            tr('DDayUpdateScreen.GoalTime'),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final selectedTime =
                                await _pickNewGoalTime(context, goalTime);
                            if (selectedTime != null) {
                              setState(() {
                                goalTime = selectedTime;
                              });
                            }
                          },
                          child: MxNcontainer(
                            MxN_rate: MxNRate.TWOBYQUARTER,
                            MxN_child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(goalTime.format(context)),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            tr('DDayUpdateScreen.Color'),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        ColorPickerWidget(
                          onColorSelected: (color) {
                            setState(() {
                              selectedColor = color;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if (_titleController.text.isEmpty) {
                      showSnackBar(
                          message: tr('DDayUpdateScreen.FillInAllFields'));
                      return;
                    }

                    final goalDateTimeByUtc = DateTime(
                      goalDate.year,
                      goalDate.month,
                      goalDate.day,
                      goalTime.hour,
                      goalTime.minute,
                    ).toUtc();

                    final dDay = DDay(
                      ddayId: widget.dDayId,
                      title: _titleController.text,
                      color: selectedColor,
                      targetDatetime:
                          (goalDateTimeByUtc.millisecondsSinceEpoch) ~/ 1000,
                    );

                    await dDayViewModel.updateDDay(widget.index, dDay);

                    if (context.mounted) {
                      context.pop();
                    }
                  },
                  child: MxNcontainer(
                    MxN_rate: MxNRate.TWOBYQUARTER,
                    MxN_child: Container(
                      color: AppColor.themeGrey,
                      child: Center(
                        child: Text(tr('DDayUpdateScreen.Save')),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
}
