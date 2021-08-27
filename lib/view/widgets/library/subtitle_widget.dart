import 'package:flutter/material.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';

class SubtitleWidget extends StatelessWidget {
  final Routine routine;
  const SubtitleWidget({Key? key, required this.routine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            Formatter.routineTotalWeights(routine),
            style: TextStyles.body2Light,
          ),
          const Text('   \u2022   ', style: TextStyles.caption1),
          Text(
            Formatter.durationInMin(routine.duration),
            style: TextStyles.body2Light,
          ),
          const Text('   \u2022   ', style: TextStyles.caption1),
          Text(
            Formatter.difficulty(routine.trainingLevel),
            style: TextStyles.body2Light,
          ),
        ],
      ),
    );
  }
}
