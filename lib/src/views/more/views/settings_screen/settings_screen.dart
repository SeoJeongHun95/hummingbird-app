import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widgets/admob_widget.dart';
import '../../widgets/settings/app_setting/app_setting_widget.dart';
import '../../widgets/settings/study_setting/study_setting_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            onPressed: () => context.pop(),
            icon: Icon(
              Icons.arrow_back_ios,
            ),
          ),
        ),
        title: Text('설정'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              AppSettingWidget(),
              StudySettingWidget(),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: AdMobWidget.showBannerAd(300),
              )
            ],
          ),
        ),
      ),
    );
  }
}
