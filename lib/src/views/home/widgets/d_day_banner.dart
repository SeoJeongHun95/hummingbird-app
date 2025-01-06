import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hummingbird/src/viewmodels/d_day_viewmodel.dart';

import '../../../models/d_day.dart';

class DDayBanner extends ConsumerWidget {
  const DDayBanner({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dDayList = ref.watch(dDayViewmodelProvider);
    return CarouselSlider(
      items: [],
      options: CarouselOptions(),
    );
  }

  //Create D-day ListTile
  List<Widget> dDayItems(List<DDay> list) {
    return list
        .map((dDay) => ListTile(
              title: Text(dDay.goalTitle),
              trailing: Text("D"),
            ))
        .toList();
  }
}
