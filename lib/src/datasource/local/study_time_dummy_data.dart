import 'dart:math';

import 'package:flutter/material.dart';

class StudyTimeDummyData {
  static List<int> studyDurations = [
    getRandomStudyDuration,
    getRandomStudyDuration,
    getRandomStudyDuration,
    getRandomStudyDuration,
    getRandomStudyDuration,
    getRandomStudyDuration,
    getRandomStudyDuration,
  ];

  static List<int> studyMonthDurations = [
    getRandomStudyDuration * 30,
    getRandomStudyDuration * 30,
    getRandomStudyDuration * 30,
    getRandomStudyDuration * 30,
    getRandomStudyDuration * 30,
    getRandomStudyDuration * 30,
    getRandomStudyDuration * 30,
  ];

  static List<int> totalWeekDuration = [
    for (int i = 0; i < DateTime.now().weekday; i++) getRandomStudyDuration
  ];

  static List<int> totalMonthDuration = [
    for (int i = 0; i < DateTime.now().day; i++) getRandomStudyDuration
  ];

  static int get totalStudyTimes => studyDurations.fold(0, (a, b) => a + b);

  static List<String> studyTitles = [
    'dsfdsfds수학',
    '과학',
    '영어',
    '국어',
    '사회',
    '역사',
    '정치',
  ];

  static List<Color> studyColors = [
    Color(0xffFFD700),
    Color(0xffFF6347),
    Color(0xffFF69B4),
    Color(0xff7FFFD4),
    Color(0xff00FF7F),
    Color(0xff00FFFF),
    Color(0xff8A2BE2),
  ];

  static int get getRandomStudyDuration {
    return Random().nextInt(24 * 3600 * 1000);
  }

  static (
    List<String> studyTitles,
    List<int> studyDurations,
    List<Color> studyColors
  ) getSortedList(List<int> durations) {
    final order = List.generate(studyTitles.length, (index) => index);
    final newDurations = [...durations];
    for (int i = 0; i < newDurations.length; i++) {
      for (int j = 0; j < newDurations.length - 1 - i; j++) {
        if (newDurations[j] < newDurations[j + 1]) {
          //int tmp = studyDurations[i];
          //int orderTmp = order[i];
          swap(newDurations, j, j + 1);
          swap(order, j, j + 1);
          //studyDurations[i] = studyDurations[j];
          //studyDurations[j] = tmp;
        }
      }
    }
    List<String> titles = [];
    List<Color> colors = [];
    for (int i = 0; i < studyTitles.length; i++) {
      titles.add(studyTitles[order[i]]);
      colors.add(studyColors[order[i]]);
    }
    return (titles, newDurations, colors);
  }

  static void swap(List<int> list, int i, int j) {
    int tmp = list[i];
    list[i] = list[j];
    list[j] = tmp;
  }
}
