import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:workout_player/styles/theme_colors.dart';

class RoutineWorkoutShimmer extends StatelessWidget {
  const RoutineWorkoutShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Shimmer.fromColors(
      baseColor: ThemeColors.card,
      highlightColor: ThemeColors.cardLight,
      child: ListView.builder(
        itemCount: 3,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Container(
              width: size.width - 32,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ThemeColors.card,
              ),
              child: const Text(''),
            ),
          );
        },
      ),
    );
  }
}
