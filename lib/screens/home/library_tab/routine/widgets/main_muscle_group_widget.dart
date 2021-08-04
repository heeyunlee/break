import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/classes/routine.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

class MainMuscleGroupWidget extends StatelessWidget {
  final Routine routine;

  const MainMuscleGroupWidget({
    Key? key,
    required this.routine,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final model = RoutineModel();
    final mainMuscleGroupList = model.getJoinedMainMuscleGroups(routine);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
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
              mainMuscleGroupList,
              style: TextStyles.body1,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.fade,
            ),
          ),
        ],
      ),
    );
  }
}
