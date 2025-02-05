import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/enum/mxnRate.dart';
import '../../../../../core/theme/colors/app_color.dart';
import '../../../../../core/utils/show_snack_bar.dart';
import '../../../../../core/widgets/color_picker_widget.dart';
import '../../../../../core/widgets/mxnContainer.dart';
import '../../../../models/subject/subject.dart';
import '../../../../viewmodels/subject/subject_viewmodel.dart';

class SubjectUpdateScreen extends ConsumerStatefulWidget {
  const SubjectUpdateScreen({
    super.key,
    required this.subject,
    required this.index,
  });

  final Subject subject;
  final int index;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SubjectUpdateScreenState();
}

class _SubjectUpdateScreenState extends ConsumerState<SubjectUpdateScreen> {
  late TextEditingController titleController;
  late String selectedColor;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.subject.title);
    selectedColor = widget.subject.color;
  }

  @override
  Widget build(BuildContext context) {
    log("Editing Subject Index: ${widget.index}");

    return Scaffold(
      appBar: AppBar(title: Text("과목 수정")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "과목 이름",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  MxNcontainer(
                    MxN_rate: MxNRate.TWOBYQUARTER,
                    MxN_child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "색상 선택",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  ColorPickerWidget(
                    initialColor: selectedColor,
                    onColorSelected: (color) {
                      setState(() {
                        selectedColor = color;
                      });
                    },
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  if (titleController.text.isEmpty) {
                    showSnackBar(message: "과목 이름을 입력해주세요.");
                    return;
                  }

                  final updatedSubject = Subject(
                    subjectId: widget.subject.subjectId,
                    title: titleController.text,
                    color: selectedColor,
                    order: widget.index,
                  );

                  ref
                      .read(subjectViewModelProvider.notifier)
                      .updateSubject(widget.index, updatedSubject);

                  context.pop();
                },
                child: MxNcontainer(
                  MxN_rate: MxNRate.TWOBYQUARTER,
                  MxN_child: Container(
                    color: AppColor.themeGrey,
                    child: Center(
                      child: Text("저장"),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
