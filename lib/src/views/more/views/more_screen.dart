import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/router/bottom_nav_bar.dart';
import '../../../providers/review/review_provider.dart';
import '../widgets/options_container_widget.dart';
import '../widgets/user_auth_widget.dart';
import '../widgets/user_profile_widget.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewService = ref.read(reviewProvider.notifier);
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              UserProfileWidget(),
              OptionsContainerModule(),
              UserAuthWidget(),
              TextButton(
                onPressed: () => reviewService.requestReview(context),
                child: const Text('리뷰 하기'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
