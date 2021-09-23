import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:workout_player/styles/theme_colors.dart';

class ListViewShimmer extends StatelessWidget {
  const ListViewShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ThemeColors.card,
      highlightColor: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: 7,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              child: Card(
                color: Colors.transparent,
                elevation: 0,
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(width: 80, height: 20, color: Colors.grey),
                          const SizedBox(height: 4),
                          Container(width: 160, height: 20, color: Colors.grey),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
