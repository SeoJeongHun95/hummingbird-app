import 'package:flutter/material.dart';

import '../../../models/d_day/d_day.dart';

class DummyData {
  static List<DDay> dummyDDayList = [
    DDay(
      title: "수능",
      targetDate: DateTime.now().add(Duration(days: 3)).millisecondsSinceEpoch,
      color: '${Colors.blue.a}${Colors.blue.r}${Colors.blue.g}${Colors.blue.b}',
    ),
    DDay(
      title: "공무원 자격증",
      targetDate: DateTime.now().add(Duration(days: 10)).millisecondsSinceEpoch,
      color: Colors.greenAccent.toString().substring(10, 16),
    ),
    DDay(
      title: "컴활 자격증",
      targetDate:
          DateTime.now().subtract(Duration(days: 3)).millisecondsSinceEpoch,
      color: Colors.purple.toString().substring(10, 16),
    )
  ];
  static List<String> colors = [
    '227C9D',
    '17C3B2',
    'FFCB77',
    'FE6D73',
    '7868E6',
    'F6D55C',
    'FF9F1C',
    'A3A1A8',
    'F0A6CA',
    'FF84B4',
    'FFB7B2',
    'FFC1A6',
    'FFD3B6',
    'E2D58B',
    'B5EAD7',
  ];
}
