import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../viewmodels/user_setting/user_setting_view_model.dart';
import '../../../../mbti/result_screen.dart';

class MbtiResoultWidget extends ConsumerWidget {
  const MbtiResoultWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSettingState = ref.watch(userSettingViewModelProvider);
    return userSettingState.when(data: (userSetting) {
      return ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        visualDensity: VisualDensity(vertical: -4),
        onTap: () {
          if (userSetting.mbti == null || userSetting.mbti == "") {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('NotificationButton.Alarm').tr(),
                  content: Text('mbtiResult.MBTINotTest').tr(), // 메시지
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // 다이얼로그 닫기
                      },
                      child: Text('WhiteNoiseScreen.Close').tr(),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // 다이얼로그 닫기
                        context.go('/more/profile');
                      },
                      child: Text(
                        'mbtiResult.GoTest',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                      ).tr(),
                    ),
                  ],
                );
              },
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultScreen(
                  mbtiType: userSetting.mbti ?? "", // Null 처리를 안전하게 함
                  isResoultScreen: true,
                ),
              ),
            );
          }
        },
        leading: Icon(Icons.edit_document, size: 20),
        title: Text(
          tr("MBTIResoltScreen.MyMBTIresult"),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
      );
    }, error: (error, stackTrace) {
      return Text("Error: $error");
    }, loading: () {
      return Center(child: CircularProgressIndicator());
    });
  }
}
