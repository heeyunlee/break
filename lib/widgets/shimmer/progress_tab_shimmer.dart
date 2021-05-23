import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants.dart';

class ProgressTabShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Shimmer.fromColors(
      baseColor: kCardColor,
      highlightColor: kCardColorLight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          const CircleAvatar(),
          const SizedBox(height: 24),
          Center(
            child: Container(
              height: 200,
              width: size.width - 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.green,
              ),
              child: Text('sd'),
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: Container(
              height: 200,
              width: size.width - 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.green,
              ),
              child: Text('sd'),
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: Container(
              height: 200,
              width: size.width - 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.green,
              ),
              child: Text('sd'),
            ),
          ),
        ],
      ),
    );
  }
}
