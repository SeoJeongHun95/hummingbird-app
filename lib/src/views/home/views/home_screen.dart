import 'package:flutter/material.dart';
import 'package:hummingbird/core/router/bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Text("HomeScreen"),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
