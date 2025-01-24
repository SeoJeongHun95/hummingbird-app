import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/settings/study_setting/select_group_container_widget.dart';

class SelectGroupScreen extends StatelessWidget {
  const SelectGroupScreen({super.key});

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
        title: Text('그룹'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SelectGroupContainerWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
