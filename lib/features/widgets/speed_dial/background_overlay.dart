import 'dart:ui';

import 'package:flutter/material.dart';

class BackgroundOverlay extends AnimatedWidget {
  final Color? color;
  final double opacity;

  const BackgroundOverlay({
    Key? key,
    required Animation<double> animation,
    this.color = Colors.black,
    this.opacity = 0.8,
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          color: color?.withOpacity(animation.value * opacity),
        ),
      ),
    );
  }
}
