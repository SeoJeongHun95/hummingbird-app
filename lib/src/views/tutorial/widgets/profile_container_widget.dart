import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/enum/mxnRate.dart';
import '../../../../core/widgets/mxnContainer.dart';
import '../../../viewmodels/user_setting/user_setting_view_model.dart';
import 'page_transition_button_widget.dart';

class ProfileContainerWidget extends StatefulWidget {
  const ProfileContainerWidget(
    this.nickName,
    this.birthDate,
    this.userSettingViewModel, {
    super.key,
  });

  final String? nickName;
  final String? birthDate;
  final UserSettingViewModel userSettingViewModel;

  @override
  State<StatefulWidget> createState() => _ProfileContainerWidgetState();
}

class _ProfileContainerWidgetState extends State<ProfileContainerWidget> {
  late final TextEditingController _nickNameController;
  late final TextEditingController _birthDateController;
  late final UserSettingViewModel userSettingViewModel;

  final _focusNode = FocusNode();
  DateTime? birthDate;

  @override
  void initState() {
    super.initState();

    _nickNameController = TextEditingController(text: widget.nickName);
    _birthDateController = TextEditingController(text: widget.birthDate);

    userSettingViewModel = widget.userSettingViewModel;
  }

  void selectDate(DateTime selectedDate) {
    setState(() {
      birthDate = selectedDate;
      _birthDateController.text = formatBirthDate(selectedDate);
    });
  }

  @override
  void dispose() {
    _nickNameController.dispose();
    _birthDateController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MxNcontainer(
            MxN_rate: MxNRate.TWOBYTHREEQUARTERS,
            MxN_child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('닉네임'),
                  SizedBox(height: 8.w),
                  TextField(
                    focusNode: _focusNode,
                    controller: _nickNameController,
                    maxLength: 30,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      hintText: "닉네임을 입력하세요",
                    ),
                    onChanged: (value) {
                      if (value.isEmpty) {
                        setState(() {});
                      }
                    },
                  ),
                  SizedBox(height: 24.w),
                  Text('생년월일'),
                  SizedBox(height: 8.w),
                  TextField(
                    controller: _birthDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          final selectedDate =
                              await showSelectBirthPicker(context);
                          if (selectedDate != null) {
                            selectDate(selectedDate);
                          }
                        },
                        icon: Icon(
                          Icons.calendar_month,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 56.w),
          SizedBox(height: 32.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              PageTransitionButtonWidget(
                title: '건너뛰기',
                backgroundColor: Colors.white,
                foregroudColor: Theme.of(context).colorScheme.primary,
                changePage: () {
                  final nickName = _nickNameController.text;
                  userSettingViewModel.addUserSetting(nickName: nickName);
                  context.go('/');
                  _nickNameController.clear();
                  _birthDateController.clear();
                },
              ),
              PageTransitionButtonWidget(
                title: '다음',
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroudColor: Colors.white,
                changePage: () => context.go('/tutorial/studySetting'),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget get divider => Divider(height: 1, color: Colors.grey);

  Future<DateTime?> showSelectBirthPicker(BuildContext context) async {
    return await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialDate: birthDate,
    );
  }

  String formatBirthDate(DateTime? date) {
    return date == null
        ? '생년월일을 선택해 보세요'
        : DateFormat('yyyy-MM-dd').format(date);
  }

  bool get isValid => _nickNameController.text.isNotEmpty;
}
