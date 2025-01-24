import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/enum/mxnRate.dart';
import '../../../../core/enum/period_option.dart';
import '../../../../core/utils/get_formatted_time.dart';
import '../../../../core/widgets/mxnContainer.dart';

class SummaryWidget extends StatelessWidget {
  const SummaryWidget({
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(targetPeriod),
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
    final seconds =
        isAverage ? (totalStudyDuration) ~/ totalDays : totalStudyDuration;

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: '$title\n\n',
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
        children: [
          TextSpan(
            text: getFormatTime(seconds),
            style: TextStyle(
              color: Colors.black,
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
