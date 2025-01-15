import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/enum/mxnRate.dart';
import '../../../../../core/widgets/mxnContainer.dart';
import '../../../../models/subject/subject.dart';
import '../../../../providers/suduck_timer/suduck_timer_provider.dart';
import '../../../../viewmodels/subject/subject_viewmodel.dart';
import '../d_day_widgets/color_picker_dialog.dart';

class SubjectListWidget extends ConsumerWidget {
  const SubjectListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjects = ref.watch(subjectViewModelProvider);

    return MxNcontainer(
      MxN_rate: MxNRate.FOURBYTHREE,
      MxN_child: Container(
        color: Colors.orange,
        child: Column(
          children: [
            subjects.when(
              data: (data) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: data.length + 1,
                    itemBuilder: (context, index) {
                      if (index == data.length) {
                        return IconButton(
                          onPressed: () => _showAddSubjectDialog(
                            context,
                            ref,
                            data.length,
                          ),
                          icon: Icon(Icons.add),
                        );
                      }

                      final subject = data[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color(
                            int.parse('0xff${subject.color}'),
                          ),
                          child: Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(subject.title),
                        trailing: MenuAnchor(
                          alignmentOffset: Offset(-17.w, 0),
                          menuChildren: [
                            MenuItemButton(
                              onPressed: () {
                                _showEditDialog(context, ref, subject, index);
                              },
                              child: Text("편집"),
                            ),
                            MenuItemButton(
                              onPressed: () {
                                ref
                                    .read(subjectViewModelProvider.notifier)
                                    .deleteSubject(index);
                              },
                              child: Text("제거"),
                            )
                          ],
                          builder: (context, controller, child) {
                            return IconButton(
                              onPressed: () {
                                if (controller.isOpen) {
                                  controller.close();
                                } else {
                                  controller.open();
                                }
                              },
                              icon: Icon(
                                Icons.more_vert,
                                size: 15.sp,
                              ),
                            );
                          },
                        ),
                        onTap: () => ref
                            .read(suDuckTimerProvider.notifier)
                            .startTimerWithSubject(subject: subject),
                      );
                    },
                  ),
                );
              },
              error: (error, stackTrace) => Center(
                child: Text('Error: $error'),
              ),
              loading: () => Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showSubjectDialog(
    BuildContext context,
    WidgetRef ref,
    String title,
    String initialTitle, {
    String? initialColor,
    required void Function(String title, String color) onConfirm,
  }) async {
    final TextEditingController titleController =
        TextEditingController(text: initialTitle);
    String? selectedColor = initialColor;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: '과목 이름'),
              ),
              TextButton(
                onPressed: () async {
                  selectedColor = await _showColorPickerDialog(context);
                },
                child: Text('색상 선택'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty && selectedColor != null) {
                  onConfirm(titleController.text, selectedColor!);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("과목 이름은 비워둘 수 없습니다")),
                  );
                }
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _showAddSubjectDialog(BuildContext context, WidgetRef ref, int order) {
    _showSubjectDialog(
      context,
      ref,
      '과목 추가',
      '',
      initialColor: "227C9D",
      onConfirm: (title, color) {
        final newSubject = Subject(title: title, color: color, order: order);
        ref.read(subjectViewModelProvider.notifier).addSubject(newSubject);
      },
    );
  }

  void _showEditDialog(
      BuildContext context, WidgetRef ref, Subject subject, int index) {
    _showSubjectDialog(
      context,
      ref,
      '과목 편집',
      subject.title,
      initialColor: subject.color,
      onConfirm: (title, color) {
        final updatedSubject = Subject(
          title: title,
          color: color,
          order: subject.order,
        );
        ref
            .read(subjectViewModelProvider.notifier)
            .updateSubject(index, updatedSubject);
      },
    );
  }

  Future<String?> _showColorPickerDialog(BuildContext context) async {
    final selectedColor = await showDialog<String>(
      context: context,
      builder: (context) {
        return ColorPickerDialog(
          oldColor: "227C9D",
        );
      },
    );
    return selectedColor;
  }
}
