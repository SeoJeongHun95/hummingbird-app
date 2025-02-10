import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity(vertical: -4),
      leading: Icon(
        Icons.notifications_outlined,
        size: 20.w,
      ),
      title: Text(
        tr("NotificationButton.Alarm"),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16.w,
      ),
    );
  }
}
