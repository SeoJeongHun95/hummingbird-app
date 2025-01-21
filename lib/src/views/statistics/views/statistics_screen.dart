import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/router/bottom_nav_bar.dart';
import 'monthly_statistics_screen.dart';
import 'weekly_statistics_screen.dart';

final List<SegmentTab> _tabs = [
  const SegmentTab(label: "주간", backgroundColor: Colors.red),
  const SegmentTab(label: "월간", backgroundColor: Colors.orange),
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
                color: Colors.lightGreen,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
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
