import 'package:flutter/material.dart';

import '../../../../core/router/bottom_nav_bar.dart';
import '../widgets/chart_scroll_view.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ChartScrollView(),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
