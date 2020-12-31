import 'dart:ui';

import 'package:flutter/material.dart';

class AppbarBlurBG extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.35)),
        ),
      ),
    );
  }
}
