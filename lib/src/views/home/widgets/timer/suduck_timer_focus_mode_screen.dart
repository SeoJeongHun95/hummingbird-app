import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SuduckTimerFocusModeWidget extends StatefulWidget {
  const SuduckTimerFocusModeWidget({super.key});

  @override
  State<SuduckTimerFocusModeWidget> createState() =>
      _SuduckTimerFocusModeWidgetState();
}

class _SuduckTimerFocusModeWidgetState
    extends State<SuduckTimerFocusModeWidget> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('가로 모드 화면')),
      body: Center(
        child: Text(
          '이 화면은 가로 모드입니다.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
