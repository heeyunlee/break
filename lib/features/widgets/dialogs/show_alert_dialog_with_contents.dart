import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool?> showAlertDialogWithContents(
  BuildContext context, {
  required String title,
  required Widget buildContent,
  required String defaultActionText,
  String? cancelAcitionText,
  Function? onPressed,
}) {
  if (!Platform.isIOS) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: buildContent,
        actions: <Widget>[
          if (cancelAcitionText != null)
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelAcitionText),
            ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(defaultActionText),
          )
        ],
      ),
    );
  }
  return showCupertinoDialog<bool>(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: buildContent,
      actions: <Widget>[
        if (cancelAcitionText != null)
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelAcitionText),
          ),
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(defaultActionText),
        ),
      ],
    ),
  );
}
