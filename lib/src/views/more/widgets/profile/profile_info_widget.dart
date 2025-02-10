import 'package:StudyDuck/core/utils/format_date.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/enum/mxnRate.dart';
import '../../../../../core/widgets/mxnContainer.dart';

class ProfileInfoWidget extends StatelessWidget {
  const ProfileInfoWidget({
    super.key,
    required this.nickNameController,
    required this.birthDateController,
    required this.focusNode,
    required this.selectDate,
    required this.validateNickName,
  });

  final TextEditingController nickNameController;
  final TextEditingController birthDateController;
  final FocusNode focusNode;
  final void Function(DateTime selectedDate) selectDate;
  final void Function() validateNickName;

  @override
  Widget build(BuildContext context) {
    return MxNcontainer(
      MxN_rate: MxNRate.TWOBYONE,
      MxN_child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tr('ProfileInfoWidget.nickName')),
            TextField(
              focusNode: focusNode,
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
            )
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
