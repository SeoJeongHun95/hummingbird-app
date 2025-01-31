import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/enum/mxnRate.dart';
import '../../../../../core/widgets/mxnContainer.dart';
import '../../../../providers/suduck_timer/suduck_timer_provider_2_0.dart';

class SuduckTimerControllBarWidget extends ConsumerStatefulWidget {
  const SuduckTimerControllBarWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SuduckTimerControllBarWidgetState();
}

class _SuduckTimerControllBarWidgetState
    extends ConsumerState<SuduckTimerControllBarWidget> {
  @override
  Widget build(BuildContext context) {
    final suduckTimerNotifier = ref.read(suDuckTimerProvider.notifier);

    return MxNcontainer(
      MxN_rate: MxNRate.TWOBYQUARTER,
      MxN_child: Container(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: suduckTimerNotifier.resetSubject,
              child: Center(
                child: Text(
                  tr("TimerControlBar.WhiteNoise"),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => context.push("/focusMode"),
              child: Center(
                child: Text(
                  tr("TimerControlBar.FocusMode"),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
