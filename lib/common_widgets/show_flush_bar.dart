import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class showFlushBar {
  showFlushBar({
    BuildContext context,
    String message,
  }) {
    Flushbar(
      blockBackgroundInteraction: false,
      messageText: Text(message, style: Subtitle2BlackBold),
      margin: EdgeInsets.all(8),
      borderRadius: 5,
      backgroundColor: Colors.white,
      duration: const Duration(seconds: 3),
    )..show(context);
  }
}
