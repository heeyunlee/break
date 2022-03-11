import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void custmFadeTransition(
  BuildContext context, {
  bool isRoot = false,
  int duration = 400,
  required Widget Function(Animation<double> animation) screenBuilder,
}) {
  HapticFeedback.mediumImpact();

  Navigator.of(context, rootNavigator: isRoot).push(
    PageRouteBuilder(
      fullscreenDialog: isRoot,
      transitionDuration: Duration(milliseconds: duration),
      transitionsBuilder: (_, animation, __, child) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      pageBuilder: (context, animation, secondaryAnimation) {
        return screenBuilder(animation);
      },
    ),
  );
}
