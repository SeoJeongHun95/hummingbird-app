import 'package:StudyDuck/core/enum/mxnRate.dart';
import 'package:StudyDuck/core/widgets/mxnContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

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
                      MxNcontainer(
                        MxN_rate: MxNRate.TWOBYTWO,
                        MxN_child: Container(
                          color: Colors.white,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  double get bottomPadding => 48.0;
}

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:intl/intl.dart';

// import '../../../core/enum/mxnRate.dart';
// import '../../../core/widgets/mxnContainer.dart';
// import '../../viewmodels/user_setting/user_setting_view_model.dart';
// import 'widgets/page_transition_button_widget.dart';

// enum PageTransitionAction { prev, next }

// class ProfileSettingScreen extends ConsumerStatefulWidget {
//   const ProfileSettingScreen({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _ProfileSettingScreenState();
// }

// class _ProfileSettingScreenState extends ConsumerState<ProfileSettingScreen> {
//   late final TextEditingController _nickNameController;
//   late final TextEditingController _birthDateController;
//   late final UserSettingViewModel userSettingViewModel;

//   final _focusNode = FocusNode();
//   DateTime? birthDate;

//   @override
//   void initState() {
//     super.initState();
//     String? nickName;
//     String? birth;
//     _nickNameController = TextEditingController();
//     _birthDateController = TextEditingController();

//     ref.listenManual(userSettingViewModelProvider, (prev, next) {
//       next.whenData((userSetting) {
//         nickName = userSetting.nickname;
//         birth = userSetting.birthDate;
//         //userSettingViewModel = ref.read(userSettingViewModelProvider.notifier);
//         _nickNameController.text = nickName ?? '';
//         _birthDateController = TextEditingController();
//         if (birth != null) {
//           birthDate = DateTime.parse(birth!);
//         }
//         _birthDateController.text = formatBirthDate(birthDate);
//       });
//     });
//   }

//   void selectDate(DateTime selectedDate) {
//     setState(() {
//       birthDate = selectedDate;
//       _birthDateController.text = formatBirthDate(selectedDate);
//     });
//   }

//   @override
//   void dispose() {
//     _nickNameController.dispose();
//     _birthDateController.dispose();
//     _focusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.only(bottom: bottomPadding),
//           child: GestureDetector(
//             behavior: HitTestBehavior.opaque,
//             onTap: () => FocusScope.of(context).unfocus(),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(height: 32.w),
//                 ClipOval(
//                   child: Image.asset(
//                     'lib/core/imgs/images/StudyDuck.png',
//                     height: 150.w,
//                     width: 150.w,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 SizedBox(height: 32.w),
//                 MxNcontainer(
//                   MxN_rate: MxNRate.TWOBYTHREEQUARTERS,
//                   MxN_child: Container(
//                     color: Colors.white,
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('닉네임'),
//                         SizedBox(height: 8.w),
//                         TextField(
//                           focusNode: _focusNode,
//                           controller: _nickNameController,
//                           maxLength: 30,
//                           decoration: InputDecoration(
//                             focusedBorder: UnderlineInputBorder(
//                               borderSide: BorderSide(color: Colors.grey),
//                             ),
//                             enabledBorder: UnderlineInputBorder(
//                               borderSide: BorderSide(color: Colors.grey),
//                             ),
//                             hintText: "닉네임을 입력하세요",
//                           ),
//                         ),
//                         SizedBox(height: 24.w),
//                         Text('생년월일'),
//                         SizedBox(height: 8.w),
//                         TextField(
//                           controller: _birthDateController,
//                           readOnly: true,
//                           decoration: InputDecoration(
//                               focusedBorder: UnderlineInputBorder(
//                                 borderSide: BorderSide(color: Colors.grey),
//                               ),
//                               enabledBorder: UnderlineInputBorder(
//                                 borderSide: BorderSide(color: Colors.grey),
//                               ),
//                               suffixIcon: IconButton(
//                                 onPressed: () async {
//                                   final selectedDate =
//                                       await showSelectBirthPicker(context);
//                                   if (selectedDate != null) {
//                                     selectDate(selectedDate);
//                                   }
//                                 },
//                                 icon: Icon(
//                                   Icons.calendar_month,
//                                 ),
//                               )),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
                // SizedBox(height: 32.w),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     PageTransitionButtonWidget(
                //       title: '건너뛰기',
                //       backgroundColor: Colors.white,
                //       foregroudColor: Theme.of(context).colorScheme.primary,
                //       changePage: () {
                //         final nickName = _nickNameController.text;
                //         userSettingViewModel.addUserSetting(nickName: nickName);
                //         context.go('/');
                //         _nickNameController.clear();
                //         _birthDateController.clear();
                //       },
                //     ),
                //     PageTransitionButtonWidget(
                //       title: '다음',
                //       backgroundColor: Theme.of(context).colorScheme.primary,
                //       foregroudColor: Colors.white,
                //       changePage: () => context.go('/tutorial/studySetting'),
                //     )
                //   ],
                // )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget get divider => Divider(height: 1, color: Colors.grey);

//   Future<DateTime?> showSelectBirthPicker(BuildContext context) async {
//     return await showDatePicker(
//       context: context,
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//       initialDate: birthDate,
//     );
//   }

//   String formatBirthDate(DateTime? date) {
//     return date == null
//         ? '생년월일을 선택해 보세요'
//         : DateFormat('yyyy-MM-dd').format(date);
//   }

//   double get bottomPadding => 48.0;
// }
