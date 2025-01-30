import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

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
    return SizedBox(
      height: 400.w,
      child: Center(
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
                    Text(tr('ProfileContainerWidget.nickname')),
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
                        hintText: tr('ProfileContainerWidget.nicknameHint'),
                      ),
                      onChanged: (value) {
                        if (value.isEmpty) {
                          setState(() {});
                        }
                      },
                    ),
                    SizedBox(height: 24.w),
                    Text(tr('ProfileContainerWidget.birthDate')),
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
                  title: tr('ProfileContainerWidget.skip'),
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
                  title: tr('ProfileContainerWidget.next'),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroudColor: Colors.white,
                  changePage: () => context.go('/tutorial/studySetting'),
                )
              ],
            )
          ],
        ),
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
        ? tr('ProfileContainerWidget.selectBirthDate')
        : DateFormat('yyyy-MM-dd').format(date);
  }

  bool get isValid => _nickNameController.text.isNotEmpty;
}
