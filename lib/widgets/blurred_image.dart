import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class BlurredImage extends StatelessWidget {
  const BlurredImage({
    Key? key,
    required this.imageProvider,
    this.bgBlurSigma = 10,
  }) : super(key: key);

  final ImageProvider imageProvider;
  final double bgBlurSigma;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: bgBlurSigma, sigmaY: bgBlurSigma),
        child: const SizedBox.expand(),
      ),
    );
  }
}
