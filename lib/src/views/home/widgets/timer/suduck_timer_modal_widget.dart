import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'suduck_timer_widget.dart';

class SuduckTimerModalWidget extends ConsumerStatefulWidget {
  const SuduckTimerModalWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SuduckTimerModalWidgetState();
}

class _SuduckTimerModalWidgetState
    extends ConsumerState<SuduckTimerModalWidget> {
  @override
  Widget build(BuildContext context) {
    return SuDuckTimerWidget();
  }
}
