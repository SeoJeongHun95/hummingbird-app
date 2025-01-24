import 'package:flutter/material.dart';

import 'goal_progress_indicator.dart';

class GoalProgressIndicatorWidget extends StatelessWidget {
  const GoalProgressIndicatorWidget({
    super.key,
    required this.width,
    required this.progress,
  });

  final double width;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: width,
      width: width,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Center(
            child: GoalProgressIndicator(
              progress: progress,
              size: width * 0.8,
              progressColor: Colors.blue,
            ),
          ),
          Center(
            child: Text(
              '${(progress * 100).toStringAsFixed(1)}%',
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
