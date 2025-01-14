import 'dart:math';

import 'package:flutter/material.dart';

class GoalProgressIndicator extends StatelessWidget {
  final double progress; // 0.0 ~ 1.0
  final double size;

  const GoalProgressIndicator({
    super.key,
    required this.progress,
    this.size = 160,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _GoalProgressIndicatorPainter(
        progress: progress,
        backgroundColor: Colors.grey,
        progressColor: Colors.blue,
      ),
    );
  }
}

class _GoalProgressIndicatorPainter extends CustomPainter {
  final double progress; // 0.0 ~ 1.0 (진행률)
  final Color backgroundColor;
  final Color progressColor;

  _GoalProgressIndicatorPainter({
    required this.progress,
    this.backgroundColor = Colors.grey,
    this.progressColor = Colors.blue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = min(size.width, size.height) / 2;
    final startAngle = pi * 3 / 4;
    final indicatorLength = pi * 3 / 2;

    // 배경 원호
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.butt;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle, // 시작 각도 (45도)
      indicatorLength, // 원호 길이 (270도)
      false,
      backgroundPaint,
    );

    // 진행 원호
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.butt;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle, // 시작 각도
      indicatorLength * (progress <= 1 ? progress : 1), // 진행 길이
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
