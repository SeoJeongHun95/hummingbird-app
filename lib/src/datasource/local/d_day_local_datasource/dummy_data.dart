import '../../../models/d_day/d_day.dart';

class DummyData {
  static List<DDay> dummyDDayList = [
    DDay(
      title: "수능",
      targetDatetime:
          DateTime.now().add(Duration(days: 3)).millisecondsSinceEpoch,
      color: '227C9D',
    ),
    DDay(
      title: "공무원 자격증",
      targetDatetime:
          DateTime.now().add(Duration(days: 10)).millisecondsSinceEpoch,
      color: '7868E6',
    ),
    DDay(
      title: "컴활 자격증",
      targetDatetime:
          DateTime.now().subtract(Duration(days: 3)).millisecondsSinceEpoch,
      color: 'A3A1A8',
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
