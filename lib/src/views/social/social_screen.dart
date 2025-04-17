import 'package:StudyDuck/core/widgets/admob_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/router/bottom_nav_bar.dart';
import 'widgets/leard_board_widget.dart';

class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr("Rank.Rank")),
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            LeaderboardWidget(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
