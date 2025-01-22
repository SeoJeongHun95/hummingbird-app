import 'package:flutter/material.dart';

import '../../../../core/enum/mxnRate.dart';
import '../../../../core/widgets/mxnContainer.dart';
import 'app_chor/privacy_policy_widget.dart';
import 'user_auth/logout_btn_widget.dart';

class UserAuthWidget extends StatelessWidget {
  const UserAuthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MxNcontainer(
      MxN_rate: MxNRate.TWOBYONE,
      MxN_child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          children: [
            PrivacyPolicyWidget(),
            Divider(),
            LogoutButtonWidget(),
          ],
        ),
      ),
    );
  }
}
