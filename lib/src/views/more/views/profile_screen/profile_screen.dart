import 'package:StudyDuck/src/views/more/widgets/profile_and_btn_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../viewmodels/user_setting/user_setting_view_model.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSettingState = ref.watch(userSettingViewModelProvider);
    final userSettingViewModel =
        ref.read(userSettingViewModelProvider.notifier);
    return userSettingState.when(
      data: (userSetting) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: context.pop,
              icon: Icon(Icons.arrow_back_ios),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => FocusScope.of(context).unfocus(),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 32.w),
                      ClipOval(
                        child: Image.asset(
                          'lib/core/imgs/images/StudyDuck.png',
                          height: 150.w,
                          width: 150.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 40.w),
                      ProfileAndBtnWidget(
                          nickName: userSetting.nickname,
                          birthDate: userSetting.birthDate,
                          userSettingViewModel: userSettingViewModel)
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      error: (error, stackTrace) => Center(child: Text('$error')),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }

  double get bottomPadding => 48.0;
}
