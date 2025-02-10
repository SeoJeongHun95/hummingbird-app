import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../viewmodels/user_setting/user_setting_view_model.dart';
import 'profile_info_widget.dart';
import 'safe_button_widget.dart';

class EditProfileWidget extends StatefulWidget {
  const EditProfileWidget({
    super.key,
    this.nickName,
    this.birthDate,
    required this.userSettingViewModel,
  });

  final String? nickName;
  final String? birthDate;
  final UserSettingViewModel userSettingViewModel;

  @override
  State<EditProfileWidget> createState() => _ProfileAndBtnWidgetState();
}

class _ProfileAndBtnWidgetState extends State<EditProfileWidget> {
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

  void validateNickName() {
    setState(() {});
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
        mainAxisSize: MainAxisSize.min,
        children: [
          ProfileInfoWidget(
            nickNameController: _nickNameController,
            birthDateController: _birthDateController,
            focusNode: _focusNode,
            selectDate: selectDate,
            validateNickName: validateNickName,
          ),
          SafeButtonWidget(
            title: '저장',
            isValid: isValid,
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroudColor: Theme.of(context).colorScheme.onPrimary,
            safeProfile: () async {
              await userSettingViewModel.updateUserSetting(
                updatedNickName: _nickNameController.text,
                updatedAge: _birthDateController.text,
              );
              if (context.mounted) {
                context.pop();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget get divider => Divider(height: 1, color: Colors.grey);

  String formatBirthDate(DateTime? date) {
    return date == null
        ? '생년월일을 선택해 보세요'
        : DateFormat('yyyy-MM-dd').format(date);
  }

  bool get isValid => _nickNameController.text.isNotEmpty;
}
