// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../enum/mxnRate.dart';

class MxNcontainer extends StatelessWidget {
  const MxNcontainer({
    super.key,
    required this.MxN_rate,
    required this.MxN_child,
  });

  final MxNRate MxN_rate;
  final Widget MxN_child;

  // ignore: unused_element
  double _calcPixel(int rate) {
    // ignore: no_leading_underscores_for_local_identifiers
    final double _pixelRate = 160.w;

    double result = 0.0;

    result = rate * _pixelRate;
    result = rate == 1 ? result : result + 16;

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: SizedBox(
        width: _calcPixel(MxN_rate.width),
        height: _calcPixel(MxN_rate.height),
        child: MxN_child,
      ),
    );
  }
}
