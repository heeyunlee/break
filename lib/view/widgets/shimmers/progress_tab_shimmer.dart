import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProgressTabShimmer extends StatelessWidget {
  const ProgressTabShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Container(
      width: size.width,
      height: size.height,
      color: theme.colorScheme.background,
      child: Shimmer.fromColors(
        baseColor: Colors.white.withOpacity(0.25),
        highlightColor: Colors.white.withOpacity(0.5),
        child: Column(
          children: [
            SizedBox(height: size.height / 7),
            const CircleAvatar(),
            const SizedBox(height: 24),
            Center(
              child: Container(
                height: size.height / 5,
                width: size.width - 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.green,
                ),
                child: const Text(''),
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Container(
                height: size.height / 5,
                width: size.width - 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.green,
                ),
                child: const Text('sd'),
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Container(
                height: size.height / 5,
                width: size.width - 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.green,
                ),
                child: const Text('sd'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
