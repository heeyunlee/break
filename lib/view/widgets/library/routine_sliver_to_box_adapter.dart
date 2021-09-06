import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view_models/routine_detail_screen_model.dart';

class RoutineSliverToBoxAdapter extends ConsumerWidget {
  const RoutineSliverToBoxAdapter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final model = watch(routineDetailScreenModelProvider);
    final size = MediaQuery.of(context).size;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Subtitle
            Row(
              children: [
                Text(
                  model.totalWeights(),
                  style: TextStyles.body2Light,
                ),
                const Text('   \u2022   ', style: TextStyles.caption1),
                Text(
                  model.duration(),
                  style: TextStyles.body2Light,
                ),
                const Text('   \u2022   ', style: TextStyles.caption1),
                Text(
                  model.difficulty(),
                  style: TextStyles.body2Light,
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// Main Muscle Group
            Row(
              children: [
                CachedNetworkImage(
                  imageUrl: kBicepEmojiUrl,
                  color: Colors.white,
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: size.width - 68,
                  child: Text(
                    model.muscleGroups(),
                    style: TextStyles.body1,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// Equipment Required
            Row(
              children: [
                const Icon(Icons.fitness_center_rounded, size: 20),
                const SizedBox(width: 16),
                SizedBox(
                  width: size.width - 68,
                  child: Text(
                    model.equipments(),
                    style: TextStyles.body1,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// Location
            Row(
              children: [
                const Icon(Icons.location_on_rounded, size: 20),
                const SizedBox(width: 16),
                Text(model.location(), style: TextStyles.body1),
              ],
            ),
            const SizedBox(height: 24),

            /// Description
            Text(
              model.description(),
              style: TextStyles.body2LightGrey,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
