import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/settings/app_setting/select_languange_container_widget.dart';

class SelectLanguageScreen extends StatelessWidget {
  const SelectLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            onPressed: () => context.pop(),
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),
        title: Text('언어'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SelectLanguangeContainerWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
