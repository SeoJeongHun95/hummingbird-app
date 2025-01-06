import 'package:flutter/material.dart';
import 'package:hummingbird/core/enum/mxnRate.dart';
import 'package:hummingbird/src/views/statistics/widgets/custom_pie_chart.dart';

import '../../../../core/router/bottom_nav_bar.dart';
import '../../../../core/widgets/mxnContainer.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: MxNcontainer(
            MxN_rate: MxNRate.TWOBYONE,
            MxN_child: CustomPieChart(),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
