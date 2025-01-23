import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../viewmodels/user_setting/user_setting_view_model.dart';
import 'widgets/profile_container_widget.dart';

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
            child: Padding(
              padding:
                  EdgeInsets.only(top: bottomPadding, bottom: bottomPadding),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => FocusScope.of(context).unfocus(),
                child: SingleChildScrollView(
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
                      ProfileContainerWidget(
                        userSetting.nickname,
                        userSetting.birthDate,
                        userSettingViewModel,
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
                  "오늘도 최선을 다해서 Study Duck과 함께...",
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

  double get bottomPadding => 48.0;
}
