import 'package:flutter/material.dart';
import 'package:hummingbird/core/router/router.dart';

Future<bool> showConfirmDialog(String title, String content) async {
  final globalContext = navigatorKey.currentState?.overlay?.context;

  if (globalContext == null) {
    return false;
  }

  return showDialog<bool?>(
    context: globalContext,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Confirm'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
