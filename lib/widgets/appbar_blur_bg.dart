import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:workout_player/constants.dart';

class AppbarBlurBG extends StatelessWidget {
  const AppbarBlurBG({
    Key? key,
    this.childWidget,
    this.color,
    this.blurSigma,
  }) : super(key: key);

  final Widget? childWidget;
  final Color? color;
  final double? blurSigma;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurSigma ?? 25.0,
          sigmaY: blurSigma ?? 25.0,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: color ?? kAppBarColor.withOpacity(0.5),
          ),
          child: childWidget,
        ),
      ),
    );
  }
}
