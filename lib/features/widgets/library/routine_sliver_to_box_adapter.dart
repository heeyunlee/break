import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/models/combined/combined_models.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/widgets/widgets.dart';

class RoutineSliverToBoxAdapter extends ConsumerWidget {
  const RoutineSliverToBoxAdapter({
    Key? key,
    required this.data,
  }) : super(key: key);

  final RoutineDetailScreenClass data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(routineDetailScreenModelProvider);
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
                  model.totalWeights(data),
                  style: TextStyles.body2Light,
                ),
                const Text('   \u2022   ', style: TextStyles.caption1),
                Text(
                  model.duration(data),
                  style: TextStyles.body2Light,
                ),
                const Text('   \u2022   ', style: TextStyles.caption1),
                Text(
                  model.difficulty(data),
                  style: TextStyles.body2Light,
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// Main Muscle Group
            Row(
              children: [
                const AdaptiveCachedNetworkImage(
                  imageUrl: kBicepEmojiUrl,
                  color: Colors.white,
                  size: Size(20, 20),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: size.width - 68,
                  child: Text(
                    model.muscleGroups(data),
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
                    model.equipments(data),
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
                Text(model.location(data), style: TextStyles.body1),
              ],
            ),
            const SizedBox(height: 24),

            /// Description
            Text(
              model.description(data),
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
