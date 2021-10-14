import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:workout_player/styles/theme_colors.dart';

class BlurredCard extends StatelessWidget {
  const BlurredCard({
    Key? key,
    this.width,
    required this.child,
  }) : super(key: key);

  final double? width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            color: ThemeColors.card.withOpacity(0.75),
            child: child,
          ),
        ),
      ),
    );
  }
}
