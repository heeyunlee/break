import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';

import 'show_alert_dialog.dart';

Future<void> showExceptionAlertDialog(
  BuildContext context, {
  required String title,
  required String exception,
}) =>
    showAlertDialog(
      context,
      title: title,
      content: exception,
      defaultActionText: S.current.ok,
    );
