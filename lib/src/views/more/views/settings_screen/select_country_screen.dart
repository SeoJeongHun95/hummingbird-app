import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/settings/study_setting/select_country_container_widget.dart';

class SelectCountryScreen extends StatelessWidget {
  const SelectCountryScreen({super.key});

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
        title: Text('국가'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            SelectCountryContainerWidget(),
          ],
        ),
      )),
    );
  }
}
