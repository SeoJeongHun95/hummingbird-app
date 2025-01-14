import 'package:flutter/material.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void showSnackBar(
    {required String message, Duration duration = const Duration(seconds: 2)}) {
  scaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      content: Text(message),
      duration: duration,
    ),
  );
}
