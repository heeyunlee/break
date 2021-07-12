import 'dart:ui';

import 'package:flutter/material.dart';

class BlurBackgroundCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double? vertPadding;
  final double? horzPadding;
  final double? borderRadius;
  final double? width;
  final double? height;

  const BlurBackgroundCard({
    Key? key,
    required this.child,
    this.color,
    this.vertPadding = 16,
    this.horzPadding = 0,
    this.borderRadius = 24,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Padding(
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
            borderRadius: BorderRadius.circular(borderRadius!),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: color ?? Colors.black38,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
