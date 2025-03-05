import 'package:flutter/material.dart';

import '../../../../core/router/bottom_nav_bar.dart';

class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  child: Text("${index + 1}"),
                ),
                title: Text("닉네임 ${index + 1}"),
                subtitle: Text("공부 시간: ${12 - index}시간 ${index * 5}분"),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
