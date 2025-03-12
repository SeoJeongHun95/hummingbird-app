import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/enum/mxnRate.dart';
import '../../../../../core/utils/get_formatted_time.dart';
import '../../../../../core/widgets/mxnContainer.dart';
import 'goal_progress_indicator_widget.dart';

class DailySummaryWidget extends StatelessWidget {
  const DailySummaryWidget(
      {super.key,
      required this.totalStudyDuration,
      required this.goalDuration});

  final int totalStudyDuration;
  final int goalDuration;

  @override
  Widget build(BuildContext context) {
    return MxNcontainer(
      MxN_rate: MxNRate.TWOBYTHREEQUARTERS,
      MxN_child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(tr("DailySummary.TodaySummary")),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GoalProgressIndicatorWidget(
                  width: 160.w,
                  progress: totalStudyDuration / goalDuration,
                ),
                Column(
                  children: [
                    getSummaryLabel(
                      tr("DailySummary.StudyTimeToday"),
                      getFormatTime(totalStudyDuration),
                    ),
                    getSummaryLabel(
                      tr("DailySummary.GoalStudyTime"),
                      getFormatTime(goalDuration),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getSummaryLabel(String title, String content) {
    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
        text: "$title\n",
        style: TextStyle(
          color: Colors.grey[700],
        ),
        children: [
          TextSpan(
            text: content,
            style: TextStyle(
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
