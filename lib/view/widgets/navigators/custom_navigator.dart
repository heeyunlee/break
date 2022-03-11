import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void customPush(
  BuildContext context, {
  required bool rootNavigator,
  required Function(BuildContext context) builder,
}) {
  HapticFeedback.mediumImpact();

  Navigator.of(context, rootNavigator: rootNavigator).push(
    Platform.isIOS
        ? CupertinoPageRoute(
            fullscreenDialog: rootNavigator,
            builder: (context) => builder(context),
          )
        : MaterialPageRoute(
            fullscreenDialog: rootNavigator,
            builder: (context) => builder(context),
          ),
  );
}
