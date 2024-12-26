import 'package:flutter/material.dart';

import '../../../../core/router/bottom_nav_bar.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Text("StatisticsScreen"),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
