import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/enum/mxnRate.dart';
import '../../../../../core/utils/get_formatted_time.dart';
import '../../../../../core/utils/show_confirm_dialog.dart';
import '../../../../../core/utils/show_snack_bar.dart';
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
    final subjects = ref.watch(subjectViewModelProvider);
    final subjectsNotifier = ref.read(subjectViewModelProvider.notifier);
    final suduckTimerNotifier = ref.read(suDuckTimerProvider.notifier);
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
                    tr("SubjectList.Subject"),
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
                                tr("SubjectList.SelfStudy"),
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
                                    data,
                                  );
                                },
                                icon: Icon(Icons.add),
                              ),
                            );
                          }

                          final subject = data[index - 1];
                          final matchedSubject = studyRecord
                              .where(
                                (e) =>
                                    e.order == subject.order &&
                                    e.title == subject.title,
                              )
                              .toList()
                              .firstOrNull;

                          return ListTile(
                            leading: GestureDetector(
                              onTap: () => suduckTimerNotifier.startTimer(
                                subject: subject,
                              ),
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
                                  child: Text(tr("SubjectList.Edit")),
                                ),
                                MenuItemButton(
                                  onPressed: () async {
                                    if (subject.subjectId == null) {
                                      return;
                                    }

                                    final confirm = await showConfirmDialog(
                                      subject.title +
                                          tr('SubjectList.DeleteSubjectPrompt'),
                                      tr("CannotUndoWarning"),
                                    );

                                    if (!confirm) {
                                      return;
                                    }

                                    subjectsNotifier.deleteSubject(
                                        subject.subjectId!, index - 1);
                                  },
                                  child: Text(tr("SubjectList.Delete")),
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
                decoration:
                    InputDecoration(labelText: tr("SubjectList.SubjectName")),
              ),
              TextButton(
                onPressed: () async {
                  selectedColor = await _showColorPickerDialog(context);
                },
                child: Text(tr("SubjectList.SelectColor")),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(tr("SubjectList.Cancel")),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty && selectedColor != null) {
                  onConfirm(titleController.text, selectedColor!);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(tr("SubjectList.EnterSubjectName"))),
                  );
                }
              },
              child: Text(tr("SubjectList.Confirm")),
            ),
          ],
        );
      },
    );
  }

  void _showAddSubjectDialog(
      BuildContext context, WidgetRef ref, int order, List<Subject> subjects) {
    _showSubjectDialog(
      context,
      ref,
      tr("SubjectList.AddSubject"),
      '',
      initialColor: "227C9D",
      onConfirm: (title, color) {
        if (subjects
            .where((element) => element.title == title)
            .toList()
            .isNotEmpty) {
          showSnackBar(message: "같은 과목이 이미 존재합니다.");
        } else {
          final newSubject = Subject(title: title, color: color, order: order);
          ref.read(subjectViewModelProvider.notifier).addSubject(newSubject);
        }
      },
    );
  }

  void _showEditDialog(
      BuildContext context, WidgetRef ref, Subject subject, int index) {
    _showSubjectDialog(
      context,
      ref,
      tr("SubjectList.EditSubject"),
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
