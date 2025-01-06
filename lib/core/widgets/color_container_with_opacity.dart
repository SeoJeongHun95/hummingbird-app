import 'package:flutter/material.dart';

class ColorContainerWithOpacity extends StatelessWidget {
  const ColorContainerWithOpacity(
      {super.key,
      required this.color,
      required this.width,
      required this.alphaOfColor,
      required this.borderRadius,
      this.child});

  final Color color;
  final double width;
  final int alphaOfColor;
  final double borderRadius;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: width,
        decoration: BoxDecoration(
          color: color.withAlpha(alphaOfColor),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: child);
  }
}
