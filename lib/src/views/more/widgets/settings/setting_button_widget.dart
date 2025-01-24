import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingButtonWidget extends StatelessWidget {
  const SettingButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity(vertical: -4),
      onTap: () {
        context.go('/more/settings');
      },
      leading: Icon(Icons.settings_outlined),
      title: Text(
        '설정',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
      trailing: Icon(Icons.arrow_forward_ios),
    );
  }
}
