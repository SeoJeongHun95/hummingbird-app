import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../viewmodels/user_setting/user_setting_view_model.dart';
import '../../../more/widgets/profile/profile_info_widget.dart';
import '../page_transition_button_widget.dart';

class SetProfileWidget extends StatefulWidget {
  const SetProfileWidget(
    this.nickName,
    this.birthDate,
    this.mbti,
    this.userSettingViewModel, {
    super.key,
  });

  final String? nickName;
  final String? birthDate;
  final String? mbti;
  final UserSettingViewModel userSettingViewModel;

  @override
  State<StatefulWidget> createState() => _ProfileContainerWidgetState();
}

class _ProfileContainerWidgetState extends State<SetProfileWidget> {
  late final TextEditingController _nickNameController;
  late final TextEditingController _birthDateController;
  late final TextEditingController _mbtiController;
  late final UserSettingViewModel userSettingViewModel;

  final _focusNode = FocusNode();
  final _nickNameFocusNode = FocusNode();
  final _mbtiFocusNode = FocusNode();
  DateTime? birthDate;

  @override
  void initState() {
    super.initState();

    _nickNameController = TextEditingController(text: widget.nickName);
    _birthDateController = TextEditingController(text: widget.birthDate);
    _mbtiController = TextEditingController(text: '');

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
    _mbtiController.dispose();
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
            mbtiController: _mbtiController,
            mbti: widget.mbti ?? '',
            nickNameFocusNode: _nickNameFocusNode,
            mbtiFocusNode: _mbtiFocusNode,
            selectDate: selectDate,
            validateNickName: validateNickName,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              PageTransitionButtonWidget(
                title: tr('SetProfileWidget.skip'),
                backgroundColor: Colors.white,
                foregroudColor: Theme.of(context).colorScheme.primary,
                changePage: () {
                  final nickName = _nickNameController.text;
                  userSettingViewModel.updateUserSetting(
                      updatedNickName: nickName);
                  context.go('/');
                  _nickNameController.clear();
                  _birthDateController.clear();
                },
              ),
              PageTransitionButtonWidget(
                title: tr('SetProfileWidget.next'),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroudColor: Colors.white,
                changePage: () async {
                  await userSettingViewModel.updateUserSetting(
                    updatedNickName: _nickNameController.text,
                    updatedAge: _birthDateController.text,
                  );
                  if (context.mounted) {
                    context.go('/tutorial/studySetting');
                  }
                },
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
        ? tr('SetProfileWidget.selectBirthDate')
        : DateFormat('yyyy-MM-dd').format(date);
  }
}
