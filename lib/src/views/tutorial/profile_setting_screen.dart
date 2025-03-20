import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../viewmodels/user_setting/user_setting_view_model.dart';
import '../more/widgets/profile/profile_image_widget.dart';
import 'widgets/profile/set_profile_widget.dart';

class ProfileSettingScreen extends ConsumerWidget {
  const ProfileSettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSettingState = ref.watch(userSettingViewModelProvider);
    final userSettingViewModel =
        ref.read(userSettingViewModelProvider.notifier);
    return userSettingState.when(
      data: (userSetting) {
        return Scaffold(
          body: SafeArea(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Gap(32.w),
                    ProfileImageWidget(radius: 88.w),
                    Gap(40.w),
                    SetProfileWidget(
                      userSetting.nickname,
                      userSetting.birthDate,
                      userSetting.mbti,
                      userSettingViewModel,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      error: (error, stackTrace) => Center(child: Text('$error')),
      loading: () {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Spacer(flex: 3),
                ClipOval(
                  child: Image.asset(
                    'lib/core/imgs/images/StudyDuck.png',
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 300,
                  child: LinearProgressIndicator(
                    value: 1,
                    backgroundColor: Colors.grey[200],
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.yellow),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  tr("ProfileSettingScreen.loadingText"),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontFamily: 'NanumPenScript',
                  ),
                ),
                const Spacer(flex: 2),
                const SizedBox(height: 80),
              ],
            ),
          ),
        );
      },
    );
  }
}
