import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/enum/mxnRate.dart';
import '../../../../core/theme/colors/app_color.dart';
import '../../../../core/widgets/mxnContainer.dart';
import '../../../viewmodels/user_setting/user_setting_view_model.dart';

class UserProfileWidget extends ConsumerWidget {
  const UserProfileWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSettingState = ref.watch(userSettingViewModelProvider);
    return userSettingState.when(
      data: (userSetting) {
        return MxNcontainer(
          MxN_rate: MxNRate.TWOBYONE,
          MxN_child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40.w,
                      backgroundImage:
                          AssetImage('lib/core/imgs/images/StudyDuck.png'),
                    ),
                    SizedBox(
                      width: 40.w,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('닉네임: ${userSetting.nickname}'),
                          SizedBox(height: 12.w),
                          getBrithDateText(userSetting.birthDate),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      context.go('/more/profile');
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: AppColor.themeGrey,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('프로필 편집'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => MxNcontainer(
        MxN_rate: MxNRate.TWOBYONE,
        MxN_child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 40.w,
                    backgroundImage:
                        AssetImage('lib/core/imgs/images/StudyDuck.png'),
                  ),
                  SizedBox(
                    width: 40.w,
                  ),
                  CircularProgressIndicator(),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    context.go('/more/profile');
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: AppColor.themeGrey,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('프로필 편집'),
                ),
              ),
            ],
          ),
        ),
      ),
      error: (error, stackTrace) => Center(
        child: Text('$error'),
      ),
    );
  }

  Widget getBrithDateText(String? birthDate) {
    return RichText(
      text: TextSpan(
        text: '생년월일: ',
        style: TextStyle(
          color: Colors.black,
        ),
        children: [
          TextSpan(
            text: birthDate ?? '생년월일을 등록해 보세요',
            style: TextStyle(
              color: birthDate == null ? Colors.grey : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
