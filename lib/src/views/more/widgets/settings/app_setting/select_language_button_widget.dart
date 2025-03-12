import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../setting_tile_widget.dart';

class SelectLanguageButtonWidget extends ConsumerWidget {
  const SelectLanguageButtonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRouterPath = GoRouterState.of(context).uri.path;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.go('$currentRouterPath/language'),
      child: SettingTileWidget(
        title: tr('SelectLanguageButtonWidget.Language'),
        selected: Text(
          tr('SelectLanguageButtonWidget.Korean'),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
              ),
        ),
      ),
    );
  }
}
