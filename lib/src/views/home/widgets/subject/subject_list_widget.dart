import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hummingbird/src/viewmodels/study_record/study_record_viewmodel.dart';

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
                          onPressed: () => _showAddSubjectDialog(context, ref),
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
                        trailing: IconButton(
                          icon: Icon(Icons.more_horiz_rounded),
                          onPressed: () {
                            _showSubjectOptionsDialog(
                              context,
                              ref,
                              subject,
                              index,
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
            IconButton(
              onPressed: () => ref
                  .read(studyRecordViewModelProvider.notifier)
                  .loadStudyRecordsByDate("2025-01-10"),
              icon: Icon(Icons.read_more),
            )
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
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Subject Title'),
              ),
              TextButton(
                onPressed: () async {
                  selectedColor = await _showColorPickerDialog(context);
                },
                child: Text('Select Color'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty && selectedColor != null) {
                  onConfirm(titleController.text, selectedColor!);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Please provide both title and color')),
                  );
                }
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _showAddSubjectDialog(BuildContext context, WidgetRef ref) {
    _showSubjectDialog(
      context,
      ref,
      'Add New Subject',
      '',
      onConfirm: (title, color) {
        final newSubject = Subject(title: title, color: color, order: 1);
        ref.read(subjectViewModelProvider.notifier).addSubject(newSubject);
      },
    );
  }

  void _showEditDialog(
      BuildContext context, WidgetRef ref, Subject subject, int index) {
    _showSubjectDialog(
      context,
      ref,
      'Edit Subject',
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

  void _showSubjectOptionsDialog(
      BuildContext context, WidgetRef ref, Subject subject, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Options for ${subject.title}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Edit Subject'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showEditDialog(context, ref, subject, index);
                },
              ),
              ListTile(
                title: Text('Delete Subject'),
                onTap: () {
                  Navigator.of(context).pop();
                  ref
                      .read(subjectViewModelProvider.notifier)
                      .deleteSubject(index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String?> _showColorPickerDialog(BuildContext context) async {
    final selectedColor = await showDialog<String>(
      context: context,
      builder: (context) {
        return ColorPickerDialog(
          oldColor: "",
        );
      },
    );
    return selectedColor;
  }
}
