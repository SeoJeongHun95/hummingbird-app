import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/auth/auth_provider.dart';

class DeleteUserButtonWidget extends ConsumerWidget {
  const DeleteUserButtonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity(vertical: -4),
      onTap: () async {
        await ref.read(authProvider.notifier).deleteUser();
      },
      leading: Icon(Icons.details_outlined, size: 20),
      title: Text(
        tr('DeleteUserButtonWidget.DeleteUser'),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
