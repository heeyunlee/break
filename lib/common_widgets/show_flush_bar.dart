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
      flushbarPosition: FlushbarPosition.TOP,
      blockBackgroundInteraction: false,
      messageText: Text(
        message,
        style: Subtitle2.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      margin: EdgeInsets.all(8),
      borderRadius: 5,
      backgroundColor: Colors.white,
      duration: const Duration(milliseconds: 1500),
    )..show(context);
  }
}
