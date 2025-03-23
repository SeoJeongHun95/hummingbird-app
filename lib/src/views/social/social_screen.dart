import 'package:flutter/material.dart';

import '../../../core/router/bottom_nav_bar.dart';
import 'widgets/leard_board_widget.dart';

class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("랭킹"),
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            LeardBoardWidget(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
