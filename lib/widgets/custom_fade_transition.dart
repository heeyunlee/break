import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

bool? custmFadeTransition(
  BuildContext context, {
  bool isRoot = false,
  int duration = 400,
  required Widget screen,
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
        return ListenableProvider(
          create: (cintext) => animation,
          child: screen,
        );
      },
    ),
  );
}
