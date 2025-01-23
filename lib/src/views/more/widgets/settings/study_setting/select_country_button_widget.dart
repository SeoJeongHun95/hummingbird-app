import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../setting_tile_widget.dart';

class SelectCountryButtonWidget extends ConsumerWidget {
  const SelectCountryButtonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPath = GoRouterState.of(context).uri.path;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.go('$currentPath/country'),
      child: SettingTileWidget(
        title: '국가',
        selected: Text(
          '대한민국',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
              ),
        ),
      ),
    );
  }
}
