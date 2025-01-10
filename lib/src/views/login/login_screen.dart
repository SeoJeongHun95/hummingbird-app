import 'package:flutter/material.dart';

import '../../../core/enum/mxnRate.dart';
import '../../../core/widgets/mxnContainer.dart';
import 'google_login_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MxNcontainer(
                    MxN_rate: MxNRate.TWOBYONE,
                    MxN_child: Text('Hummingbird logo'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MxNcontainer(
                    MxN_rate: MxNRate.TWOBYONE,
                    MxN_child: Column(
                      children: [
                        GoogleLoginButton(),
                        //   TODO: Add apple login button
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
