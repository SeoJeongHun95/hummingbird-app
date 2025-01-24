import 'package:flutter/material.dart';

import '../../../../../../core/enum/mxnRate.dart';
import '../../../../../../core/widgets/mxnContainer.dart';
import 'select_country_button_widget.dart';
import 'select_goal_duration_button_widget.dart';
import 'select_group_button_widget.dart';

class StudySettingWidget extends StatelessWidget {
  const StudySettingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MxNcontainer(
      MxN_rate: MxNRate.TWOBYONE,
      MxN_child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          children: [
            SelectCountryButtonWidget(),
            Divider(),
            SelectGroupButtonWidget(),
            Divider(),
            SelectGoalDurationButtonWidget(),
          ],
        ),
      ),
    );
  }
}
