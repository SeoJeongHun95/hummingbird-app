import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'timer_bg_color_provider.g.dart';

@Riverpod(keepAlive: true)
class TimerBgColor extends _$TimerBgColor {
  final Color _initColor = Color(0xffba4849);

  @override
  Color build() {
    return _initColor;
  }

  void changeColor({String? color}) {
    state = color != null ? Color(int.parse("0xff$color")) : _initColor;
  }
}
