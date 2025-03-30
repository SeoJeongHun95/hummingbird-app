import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../providers/auth/auth_provider.dart';
import '../../oss_licenses_screen.dart';

class OssLicensesWidge extends ConsumerWidget {
  const OssLicensesWidge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity(vertical: -4),
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OssLicensesScreen()),
        );
      },
      leading: Icon(Icons.rule, size: 20),
      title: Text(
        tr('License.License'),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
