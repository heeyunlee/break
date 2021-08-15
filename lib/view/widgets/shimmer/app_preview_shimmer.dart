import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:workout_player/styles/constants.dart';

class AppPreviewShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Shimmer.fromColors(
      baseColor: kBackgroundColor,
      highlightColor: Colors.grey[800]!,
      child: Container(
        height: size.height * 3 / 4,
        width: size.width * 3 / 4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Platform.isIOS ? 40 : 24),
          color: kCardColor,
        ),
      ),
    );
  }
}
