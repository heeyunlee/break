import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants.dart';

class AppPreviewShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Shimmer.fromColors(
      baseColor: BackgroundColor,
      highlightColor: BackgroundColor,
      child: Container(
        height: size.height * 5 / 6,
        width: size.width * 5 / 6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(45),
          color: CardColor,
        ),
      ),
    );
  }
}
