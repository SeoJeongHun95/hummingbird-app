import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/enum/mxnRate.dart';
import '../../../../../core/utils/format_date.dart';
import '../../../../../core/widgets/mxnContainer.dart';

class ProfileInfoWidget extends StatelessWidget {
  const ProfileInfoWidget({
    super.key,
    required this.nickNameController,
    required this.birthDateController,
    required this.mbtiController,
    required this.nickNameFocusNode,
    required this.mbtiFocusNode,
    required this.selectDate,
    required this.validateNickName,
    required this.mbti,
  });

  final TextEditingController nickNameController;
  final TextEditingController birthDateController;
  final TextEditingController mbtiController;
  final FocusNode nickNameFocusNode;
  final FocusNode mbtiFocusNode;
  final void Function(DateTime selectedDate) selectDate;
  final void Function() validateNickName;
  final String mbti;

  @override
  Widget build(BuildContext context) {
    return MxNcontainer(
      MxN_rate: MxNRate.TWOBYTHREEQUARTERS,
      MxN_child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tr('ProfileInfoWidget.nickName')),
                TextField(
                  focusNode: nickNameFocusNode,
                  controller: nickNameController,
                  maxLength: 30,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    hintText: tr('ProfileInfoWidget.nickNameHint'),
                  ),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      validateNickName();
                    }
                  },
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tr('ProfileInfoWidget.birthDate')),
                TextField(
                  controller: birthDateController,
                  readOnly: true,
                  onTap: () async {
                    final selectedDate = await showSelectBirthPicker(
                      context,
                      birthDateController.text,
                    );

                    if (selectedDate != null) {
                      selectDate(selectedDate);
                    }
                  },
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    suffixIcon: Icon(Icons.calendar_month),
                  ),
                ),
              ],
            ),
            Gap(8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tr('MBTI')),
                TextField(
                  onTap: () {
                    GoRouter.of(context).go('/mbti');
                  },
                  readOnly: true,
                  focusNode: mbtiFocusNode,
                  controller: mbtiController,
                  maxLength: 4,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    hintText: tr('ProfileInfoWidget.mbtiTest'),
                    suffixIcon: Icon(Icons.pending_actions),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> showSelectBirthPicker(
      BuildContext context, String birthDate) async {
    if (birthDate == '') {
      birthDate = formatDate(DateTime.now());
    }
    return await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialDate: DateTime.parse(birthDate),
    );
  }
}
