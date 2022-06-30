import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RoutineWorkoutShimmer extends StatelessWidget {
  const RoutineWorkoutShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Shimmer.fromColors(
      baseColor: theme.cardTheme.color!,
      highlightColor: theme.primaryColor.withOpacity(0.12),
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
                color: theme.cardTheme.color!,
              ),
              child: const Text(''),
            ),
          );
        },
      ),
    );
  }
}
