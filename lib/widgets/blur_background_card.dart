import 'dart:ui';

import 'package:flutter/material.dart';

class BlurBackgroundCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double? vertPadding;
  final double? horzPadding;
  final double? borderRadius;

  const BlurBackgroundCard({
    Key? key,
    required this.child,
    this.color = Colors.black54,
    this.vertPadding = 16,
    this.horzPadding = 0,
    this.borderRadius = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: vertPadding!,
        horizontal: horzPadding!,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.14),
              blurRadius: 5,
              offset: Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 10,
              offset: Offset(0, 1),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.20),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
            child: Container(color: color!, child: child),
          ),
        ),
      ),
    );
  }
}
