import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/router/bottom_nav_bar.dart';
import '../../../../core/theme/colors/app_color.dart';
import 'monthly_statistics_screen.dart';
import 'weekly_statistics_screen.dart';

final List<SegmentTab> _tabs = [
  SegmentTab(
    label: tr('StatisticsScreen.weekly'),
    textColor: Colors.black,
    color: Colors.white,
    backgroundColor: AppColor.themeGrey,
  ),
  SegmentTab(
    label: tr('StatisticsScreen.monthly'),
    textColor: Colors.black,
    color: Colors.white,
    backgroundColor: AppColor.themeGrey,
  ),
];

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
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
        body: SafeArea(
          child: TabBarView(
            children: [
              WeeklyStatisticsScreen(),
              MonthlyStatisticsScreen(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavBar(),
      ),
    );
  }
}
