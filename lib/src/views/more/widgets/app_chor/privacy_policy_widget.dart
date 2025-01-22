import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyWidget extends StatelessWidget {
  const PrivacyPolicyWidget({super.key});

  Future<void> _launchURL(BuildContext context) async {
    final Uri url = Uri.parse(
        'https://plip.kr/pcc/16703898-5dde-4455-a4b2-48b4cd47a11c/privacy/1.html'); // URL 수정

    try {
      final canLaunchResult = await canLaunchUrl(url);
      if (!canLaunchResult) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('이 URL을 실행할 수 없습니다'),
              duration: Duration(seconds: 2),
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
            content: Text('URL을 열 수 없습니다: ${url.toString()}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('오류가 발생했습니다: ${e.toString()}'),
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
        size: leadingIconSize,
      ),
      title: Text(
        '개인정보 처리방침',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: trailingIconSize,
      ),
    );
  }

  double get trailingIconSize => 16.w;
  double get leadingIconSize => 20.w;
}
