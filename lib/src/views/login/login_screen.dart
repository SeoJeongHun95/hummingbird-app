import 'package:flutter/material.dart';
import 'package:hummingbird/core/router/bottom_nav_bar.dart';
import 'package:hummingbird/src/views/login/google_login_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: GoogleLoginButton(),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
