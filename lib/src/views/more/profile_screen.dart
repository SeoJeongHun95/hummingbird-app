import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../viewmodels/user_setting/user_setting_view_model.dart';
import 'widgets/profile/edit_profile_widget.dart';
import 'widgets/profile/profile_image_widget.dart';

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
            backgroundColor: Theme.of(context).colorScheme.surface,
            scrolledUnderElevation: 0,
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(bottom: 48.0),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => FocusScope.of(context).unfocus(),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Gap(32.w),
                      ProfileImageWidget(radius: 88.w),
                      Gap(40.w),
                      EditProfileWidget(
                        nickName: userSetting.nickname,
                        birthDate: userSetting.birthDate,
                        userSettingViewModel: userSettingViewModel,
                      ),
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
}
