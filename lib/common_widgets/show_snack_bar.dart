import 'package:flutter/material.dart';
import 'package:workout_player/constants.dart';

class ShowSnackBar {
  static void showSnackBar({
    GlobalKey<ScaffoldState> scaffoldKey,
    String message,
  }) {
    scaffoldKey.currentState.hideCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(8),
        backgroundColor: Colors.white,
        content: Text(message, style: Subtitle2.copyWith(color: Colors.black)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
    );
  }
}
