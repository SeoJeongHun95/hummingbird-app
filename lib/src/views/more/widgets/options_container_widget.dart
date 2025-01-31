import 'package:flutter/material.dart';

import '../../../../core/enum/mxnRate.dart';
import '../../../../core/widgets/mxnContainer.dart';
import 'notification/notification_button.dart';
import 'settings/setting_button_widget.dart';

class OptionsContainerWidget extends StatelessWidget {
  const OptionsContainerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MxNcontainer(
      MxN_rate: MxNRate.TWOBYONE,
      MxN_child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          children: [
            SettingButtonWidget(),
            const Divider(),
            NotificationButton(),
          ],
        ),
      ),
    );
  }
}
