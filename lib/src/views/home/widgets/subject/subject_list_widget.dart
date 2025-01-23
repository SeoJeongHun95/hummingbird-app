import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/enum/mxnRate.dart';
import '../../../../../core/utils/get_formatted_time.dart';
import '../../../../../core/utils/show_confirm_dialog.dart';
import '../../../../../core/widgets/mxnContainer.dart';
import '../../../../models/subject/subject.dart';
import '../../../../providers/suduck_timer/suduck_timer_provider_2_0.dart';
import '../../../../viewmodels/study_record/study_record_viewmodel.dart';
import '../../../../viewmodels/subject/subject_viewmodel.dart';
import '../d_day_widget/color_picker_dialog.dart';

class SubjectListWidget extends ConsumerWidget {
  const SubjectListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suduckTimerNotifier = ref.read(suDuckTimerProvider.notifier);
    final subjects = ref.watch(subjectViewModelProvider);
    final studyRecord = ref.watch(studyRecordViewModelProvider);

    return studyRecord.when(
      data: (recordData) {
        final studyRecord = ref
            .read(studyRecordViewModelProvider.notifier)
            .loadMergedStudyRecordsByDate(recordData);

        return MxNcontainer(
          MxN_rate: MxNRate.TWOBYTHREEQUARTERS,
          MxN_child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    "과목",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                subjects.when(
                  data: (data) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: data.length + 2,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return ListTile(
                              onTap: () => suduckTimerNotifier.resetSubject(),
                              leading: GestureDetector(
                                onTap: () => suduckTimerNotifier.startTimer(),
                                child: CircleAvatar(
                                  backgroundColor:
                                      Color(int.parse('0xffba4849')),
                                  child: Icon(Icons.play_arrow_rounded,
                                      color: Colors.white),
                                ),
                              ),
                              title: Text(
                                "자율 학습",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }

                          if (index == data.length + 1) {
                            return Center(
                              child: IconButton(
                                onPressed: () {
                                  _showAddSubjectDialog(
                                    context,
                                    ref,
                                    data.length,
                                  );
                                },
                                icon: Icon(Icons.add),
                              ),
                            );
                          }

                          final subject = data[index - 1];
                          final matchedSubject = studyRecord
                              .where((e) =>
                                  e.order == subject.order &&
                                  e.title == subject.title)
                              .toList()
                              .firstOrNull;

                          return ListTile(
                            leading: GestureDetector(
                              onTap: () => suduckTimerNotifier.startTimer(
                                  subject: subject),
                              child: CircleAvatar(
                                backgroundColor:
                                    Color(int.parse('0xff${subject.color}')),
                                child: Icon(Icons.play_arrow_rounded,
                                    color: Colors.white),
                              ),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    subject.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  width: 64.w,
                                  child: matchedSubject != null &&
                                          matchedSubject.elapsedTime != 0
                                      ? Text(
                                          getFormatTime(
                                              matchedSubject.elapsedTime),
                                          style: TextStyle(fontFeatures: [
                                            FontFeature.tabularFigures()
                                          ]),
                                        )
                                      : const Text(""),
                                )
                              ],
                            ),
                            trailing: MenuAnchor(
                              alignmentOffset: Offset(-17.w, 0),
                              menuChildren: [
                                MenuItemButton(
                                  onPressed: () {
                                    _showEditDialog(
                                        context, ref, subject, index - 1);
                                  },
                                  child: Text("편집"),
                                ),
                                MenuItemButton(
                                  onPressed: () async {
                                    if (subject.subjectId == null) {
                                      return;
                                    }

                                    final confirm = await showConfirmDialog(
                                        '${subject.title} 과목을 삭제하시겠습니까?',
                                        '해당 작업은 복구할 수 없습니다.');

                                    if (!confirm) {
                                      return;
                                    }

                                    ref
                                        .read(subjectViewModelProvider.notifier)
                                        .deleteSubject(
                                            subject.subjectId!, index - 1);
                                  },
                                  child: Text("제거"),
                                ),
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
                                  icon: Icon(Icons.more_vert, size: 15.sp),
                                );
                              },
                            ),
                            onTap: () =>
                                suduckTimerNotifier.setSubject(subject),
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
      },
      error: (error, stackTrace) => Text('$error'),
      loading: () => CircularProgressIndicator.adaptive(),
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
                    SnackBar(content: Text('과목이름을 입력해주세요')),
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
          subjectId: subject.subjectId,
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
