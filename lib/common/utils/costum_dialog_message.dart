import 'package:flutter/material.dart';

Future<void> dialogBuilder({
  required BuildContext context,
  required String titleText,
  required String disableText,
  required String enableText,
  required Function() enable,
}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          titleText,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: Text(disableText),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            onPressed: enable,
            child: Text(enableText),
          ),
        ],
      );
    },
  );
}
