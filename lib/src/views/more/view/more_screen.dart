import 'package:flutter/material.dart';
import 'package:hummingbird/core/router/bottom_nav_bar.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Text("MoreScreen"),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
