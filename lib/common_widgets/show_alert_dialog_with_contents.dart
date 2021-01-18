import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool> showAlertDialogWithContents(
  BuildContext context, {
  @required String title,
  @required Widget buildContent,
  @required String defaultActionText,
  String cancelAcitionText,
  Function onPressed,
}) {
  if (!Platform.isIOS) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: buildContent,
        actions: <Widget>[
          if (cancelAcitionText != null)
            FlatButton(
              child: Text(cancelAcitionText),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          FlatButton(
            child: Text(defaultActionText),
            onPressed: () => Navigator.of(context).pop(true),
          )
        ],
      ),
    );
  }
  return showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: buildContent,
      actions: <Widget>[
        if (cancelAcitionText != null)
          CupertinoDialogAction(
            child: Text(cancelAcitionText),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        CupertinoDialogAction(
          child: Text(defaultActionText),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );
}
