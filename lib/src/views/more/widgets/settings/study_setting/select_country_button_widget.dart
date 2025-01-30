import 'package:easy_localization/easy_localization.dart';
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
        title: tr('SelectCountryButtonWidget.Country'),
        selected: Text(
          tr('SelectCountryButtonWidget.SouthKorea'),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
              ),
        ),
      ),
    );
  }
}
