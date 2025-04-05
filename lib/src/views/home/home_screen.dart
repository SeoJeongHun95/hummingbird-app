import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/router/bottom_nav_bar.dart';
import '../../../core/theme/colors/app_color.dart';
import '../../../core/widgets/admob_widget.dart';
import '../white_noise/drawer_white_noise_controller.dart';
import 'home_seg1_screen.dart';
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

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // 위젯이 처음 생성될 때 _showBottomSheet 함수를 호출합니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showBottomSheet();
    });
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          color: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tr("Common.Advertisement"), // 광고임을 알리는 텍스트 (선택 사항)
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
              ),
              SizedBox(height: 8.h),
              AdMobWidget.showBannerAd(100.h), // 실제 광고 위젯
              SizedBox(height: 16.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    child: Text(tr("Common.Close"),
                        style:
                            TextStyle(fontSize: 16.sp, color: Colors.white))),
              ),
            ],
          ),
        );
      },
    );
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
