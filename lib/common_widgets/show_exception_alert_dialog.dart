import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'show_alert_dialog.dart';

Future<void> ShowExceptionAlertDialog(
  BuildContext context, {
  @required String title,
  @required Exception exception,
}) =>
    showAlertDialog(
      context,
      title: title,
      content: _message.toString(),
      defaultActionText: 'OK',
    );

String _message(Exception exception) {
  if (exception is FirebaseException) {
    return exception.message;
  }
  return exception.toString();
}
