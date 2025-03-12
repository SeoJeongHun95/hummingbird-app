import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DDayBanner extends StatelessWidget {
  const DDayBanner({
    super.key,
    required this.dDayTitles,
    required this.dDayIndicators,
  });

  final List<String> dDayTitles;
  final List<String> dDayIndicators;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 280.w,
      child: CarouselSlider(
        items: getDDayBannerList(dDayTitles, dDayIndicators),
        options: CarouselOptions(
            scrollDirection: Axis.vertical,
            autoPlay: true,
            height: 50.h,
            enlargeCenterPage: false,
            viewportFraction: 1,
            autoPlayInterval: const Duration(seconds: 2)),
      ),
    );
  }

  List<Widget> getDDayBannerList(List<String> titles, List<String> indicators) {
    return List.generate(
      titles.length,
      (index) {
        return ListTile(
          dense: true,
          leading: Icon(Icons.calendar_month, size: 15.sp),
          title: Text(titles[index]),
          trailing: Text(indicators[index]),
        );
      },
    );
  }
}
