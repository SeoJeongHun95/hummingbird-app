import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyWidget extends StatelessWidget {
  const PrivacyPolicyWidget({super.key});

  Future<void> _launchURL(BuildContext context) async {
    final Uri url = Uri.parse(
        'https://hazel-wallaby-265.notion.site/Study-Duck-183954afbc8480ed96c2dac4049616df');

    try {
      final canLaunchResult = await canLaunchUrl(url);
      if (!canLaunchResult) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(tr("PrivacyPolicyWidget.URLCannotBeOpened")),
              duration: const Duration(seconds: 2),
            ),
          );
        }
        return;
      }

      final launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(tr("PrivacyPolicyWidget.URLFailedToOpen",
                args: [url.toString()])),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                tr("PrivacyPolicyWidget.URLLaunchError", args: [e.toString()])),
            duration: const Duration(seconds: 2),
          ),
        );
      }
      debugPrint('URL 실행 중 오류 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity(vertical: -4),
      onTap: () {
        _launchURL(context);
      },
      leading: Icon(
        Icons.privacy_tip_outlined,
        size: 20.w,
      ),
      title: Text(
        tr("PrivacyPolicyWidget.PrivacyPolicy"),
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
