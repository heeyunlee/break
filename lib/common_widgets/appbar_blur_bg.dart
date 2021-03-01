import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:workout_player/constants.dart';

class AppbarBlurBG extends StatelessWidget {
  const AppbarBlurBG({
    Key key,
    this.childWidget,
    this.color,
  }) : super(key: key);

  final Widget childWidget;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
        child: Container(
          decoration: BoxDecoration(
            color: color ?? AppBarColor.withOpacity(0.5),
          ),
          child: childWidget,
        ),
      ),
    );
  }
}
