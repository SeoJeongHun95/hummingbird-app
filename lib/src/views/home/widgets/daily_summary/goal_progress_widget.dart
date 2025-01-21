import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/enum/mxnRate.dart';
import '../../../../../core/widgets/mxnContainer.dart';
import 'goal_progress_indicator.dart';

class GoalProgressWidget extends StatelessWidget {
  const GoalProgressWidget(
      {super.key,
      required this.totalStudyDuration,
      required this.goalDuration});

  final int totalStudyDuration;
  final int goalDuration;

  @override
  Widget build(BuildContext context) {
    return MxNcontainer(
      MxN_rate: MxNRate.FOURBYTHREE,
      MxN_child: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Positioned(
              left: 15.w,
              top: 12.w,
              child: Text(
                '금일 공부 요약',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              left: 10.w,
              bottom: 70.w,
              child: getProgressIndicator(180.w),
            ),
            Positioned(
              right: 30.w,
              bottom: 100.w,
              child: getSummaryLabel(
                '금일 공부시간',
                formatTime(totalStudyDuration),
              ),
            ),
            Positioned(
              right: 30.w,
              bottom: 40.w,
              child: getSummaryLabel(
                '목표 공부시간',
                formatTime(goalDuration),
              ),
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
        text: '$title\n',
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 14.sp,
          height: 1.5,
        ),
        children: [
          TextSpan(
            text: content,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.sp,
            ),
          )
        ],
      ),
    );
  }

  Widget getProgressIndicator(double width) {
    return SizedBox(
      height: width,
      width: width,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Positioned(
            bottom: 15.w,
            child: GoalProgressIndicator(
              progress: progress,
              size: width * 0.8,
            ),
          ),
          Positioned(
            bottom: 0,
            child: Text(
              '${(progress * 100).toStringAsFixed(1)}%',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String formatTime(int sec) {
    final hours = sec ~/ (60 * 60);
    final minutes = (sec % (60 * 60)) ~/ (60);
    final seconds = (sec % (60));

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double get progress => totalStudyDuration / goalDuration;
}
