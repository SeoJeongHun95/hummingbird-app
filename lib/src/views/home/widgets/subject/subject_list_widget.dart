import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/enum/mxnRate.dart';
import '../../../../../core/utils/get_formatted_time.dart';
import '../../../../../core/utils/show_confirm_dialog.dart';
import '../../../../../core/widgets/mxnContainer.dart';
import '../../../../providers/suduck_timer/suduck_timer_provider_2_0.dart';
import '../../../../viewmodels/study_record/study_record_viewmodel.dart';
import '../../../../viewmodels/subject/subject_viewmodel.dart';

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
                                  context.push(
                                    "/subjectAdd",
                                    extra: [data, data.length],
                                  );
                                  // _showAddSubjectDialog(
                                  //   context,
                                  //   ref,
                                  //   data.length,
                                  //   data,
                                  // );
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
                                    context.push(
                                      "/subjectUpdate",
                                      extra: [subject, index - 1],
                                    );
                                    // _showEditDialog(
                                    //     context, ref, subject, index - 1);
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
}
