import 'package:easy_localization/easy_localization.dart';
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
    this.mbti,
    required this.userSettingViewModel,
  });

  final String? nickName;
  final String? birthDate;
  final String? mbti;
  final UserSettingViewModel userSettingViewModel;

  @override
  State<EditProfileWidget> createState() => _ProfileAndBtnWidgetState();
}

class _ProfileAndBtnWidgetState extends State<EditProfileWidget> {
  late final TextEditingController _nickNameController;
  late final TextEditingController _birthDateController;
  late final TextEditingController _mbtiController;
  late final UserSettingViewModel userSettingViewModel;

  final _nickNameFocusNode = FocusNode();
  final _mbtiFocusNode = FocusNode();
  DateTime? birthDate;

  @override
  void initState() {
    super.initState();

    _nickNameController = TextEditingController(text: widget.nickName);
    _birthDateController = TextEditingController(text: widget.birthDate);
    _mbtiController = TextEditingController(text: widget.mbti ?? '');

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
    _mbtiController.dispose();
    _nickNameFocusNode.dispose();
    _mbtiFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ProfileInfoWidget(
            nickNameController: _nickNameController,
            birthDateController: _birthDateController,
            mbtiController: _mbtiController,
            nickNameFocusNode: _nickNameFocusNode,
            mbtiFocusNode: _mbtiFocusNode,
            selectDate: selectDate,
            validateNickName: validateNickName,
            mbti: '',
          ),
          const SizedBox(height: 2), // 간격을 8로 줄임
          SafeButtonWidget(
            title: tr('ProfileInfoWidget.save'),
            isValid: isValid,
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroudColor: Theme.of(context).colorScheme.onPrimary,
            safeProfile: () async {
              await userSettingViewModel.updateUserSetting(
                updatedNickName: _nickNameController.text,
                updatedAge: _birthDateController.text,
                updatedMbti: _mbtiController.text,
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
