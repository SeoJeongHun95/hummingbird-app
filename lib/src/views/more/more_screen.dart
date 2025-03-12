import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router/bottom_nav_bar.dart';
import 'widgets/options_container_widget.dart';
import 'widgets/profile/user_profile_widget.dart';
import 'widgets/user_auth_widget.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              UserProfileWidget(),
              OptionsContainerWidget(),
              UserAuthWidget(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
