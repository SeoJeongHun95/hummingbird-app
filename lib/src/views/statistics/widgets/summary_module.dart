import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../core/enum/mxnRate.dart';
import '../../../../core/enum/period_option.dart';
import '../../../../core/widgets/mxnContainer.dart';

class SummaryModule extends StatelessWidget {
  const SummaryModule({
    super.key,
    required this.totalStudyDuration,
    required this.selectedPeriod,
    required this.targetMonth,
    required this.targetWeekStartDate,
  });

  final int totalStudyDuration;
  final PeriodOption selectedPeriod;
  final DateTime targetMonth;
  final DateTime targetWeekStartDate;

  @override
  Widget build(BuildContext context) {
    return MxNcontainer(
      MxN_rate: MxNRate.TWOBYONE,
      MxN_child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              targetPeriod,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            Gap(20.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                getSummaryRichText(context, '총 공부시간', false),
                getSummaryRichText(context, '평균 공부시간', true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getSummaryRichText(
      BuildContext context, String title, bool isAverage) {
    final totalDays = PeriodOption.WEEKLY == selectedPeriod
        ? DateTime.now().weekday
        : DateTime.now().day;
    final dur = isAverage
        ? (totalStudyDuration / 1000) ~/ totalDays
        : totalStudyDuration / 1000;
    final hour = dur ~/ 3600;
    final min = (dur % 3600) ~/ 60;
    final sec = dur % 60;
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: '$title\n\n',
        style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold),
        children: [
          TextSpan(
            text:
                '${hour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}:${sec.toStringAsFixed(0).padLeft(2, '0')}',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  String get targetPeriod {
    return switch (selectedPeriod) {
      PeriodOption.WEEKLY =>
        '${DateFormat('yyyy-MM-dd').format(targetWeekStartDate)} ~ ${DateFormat('yyyy-MM-dd').format(targetWeekStartDate.add(Duration(days: 6)))}',
      _ => DateFormat('MMMM  yyyy').format(targetMonth),
    };
  }
}
