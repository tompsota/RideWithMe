
import 'package:flutter/material.dart';

Future<dynamic> showTimedAlertDialog(BuildContext context, String title, String content, [Duration duration = const Duration(seconds: 3)]) {
  return showDialog(
    context: context,
    builder: (_) {

      bool manuallyClosed = false;
      Future.delayed(duration).then((_) {
        if (!manuallyClosed) {
          Navigator.of(context, rootNavigator: true).pop('dialog');
          // Navigator.of(context).pop();
        }
      });

      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              manuallyClosed = true;
              Navigator.of(context, rootNavigator: true).pop('dialog');
              // Navigator.of(context).pop();
            },
          ),
        ]
      );
    },
    barrierDismissible: true,
  );
}

Future<dynamic> showTimedAlertDialogError(
    BuildContext context,
    { String content = 'Something went wrong!',
      String title = 'Oops...',
      Duration duration = const Duration(seconds: 3),
      Color color = Colors.redAccent
    }) {
  return showTimedAlertDialog(context, title, content, duration);
}

Future<dynamic> showTimedAlertDialogSuccess(
    BuildContext context,
    { String content = 'Operation was successful...',
      String title = 'Success!',
      Duration duration = const Duration(seconds: 3),
      Color color = Colors.greenAccent
    }) {
  return showTimedAlertDialog(context, title, content, duration);
}