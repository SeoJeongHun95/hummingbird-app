import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/router/bottom_nav_bar.dart';
import '../../providers/suduck_timer/suduck_timer_provider_2_0.dart'; // Corrected import path
import '../../../core/theme/colors/app_color.dart';
import '../../../core/widgets/admob_widget.dart';
import '../white_noise/drawer_white_noise_controller.dart';
import 'home_seg1_screen.dart';
import 'widgets/breathing_exercise_widget.dart'; // Import the new widget
import 'home_seg2_screen.dart';
import 'home_seg3_screen.dart';

final List<SegmentTab> _tabs = [
  SegmentTab(
    label: tr("HomeSegmentBar.Timer"),
    textColor: Colors.black,
    color: Colors.white,
    backgroundColor: AppColor.themeGrey,
  ),
  SegmentTab(
    label: tr("HomeSegmentBar.Dday"),
    textColor: Colors.black,
    color: Colors.white,
    backgroundColor: AppColor.themeGrey,
  ),
  SegmentTab(
    label: tr("HomeSegmentBar.Summary"),
    textColor: Colors.black,
    color: Colors.white,
    backgroundColor: AppColor.themeGrey,
  ),
];

class HomeScreen extends ConsumerStatefulWidget {
  // Change to ConsumerStatefulWidget
  @override
  ConsumerState<HomeScreen> createState() =>
      _HomeScreenState(); // Change to ConsumerState
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // Change to ConsumerState
  @override
  void initState() {
    super.initState();
    // 위젯이 처음 생성될 때 _showBottomSheet 함수를 호출합니다. (타이머가 실행 중이지 않을 때만)
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColor.themeGrey,
                width: 1.w,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SegmentedTabControl(
              selectedTabTextColor: Colors.black,
              tabPadding: EdgeInsets.zero,
              height: 36.h,
              tabs: _tabs,
            ),
          ),
        ),
        drawer: DrewerWhiteNoiseController(),
        body: SafeArea(
          child: TabBarView(
            children: [
              Seg1Screen(),
              Seg2Screen(),
              Seg3Screen(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavBar(),
      ),
    );
  }
}
