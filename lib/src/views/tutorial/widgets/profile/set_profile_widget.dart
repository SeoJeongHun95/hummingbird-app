import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../viewmodels/user_setting/user_setting_view_model.dart';
import '../../../more/widgets/user_profile/profile_info_widget.dart';
import '../page_transition_button_widget.dart';

class SetProfileWidget extends StatefulWidget {
  const SetProfileWidget(
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

class _ProfileContainerWidgetState extends State<SetProfileWidget> {
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

  void validateNickName() {
    setState(() {});
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          ProfileInfoWidget(
            nickNameController: _nickNameController,
            birthDateController: _birthDateController,
            focusNode: _focusNode,
            selectDate: selectDate,
            validateNickName: validateNickName,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
