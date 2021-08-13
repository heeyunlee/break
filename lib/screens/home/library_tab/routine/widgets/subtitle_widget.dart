import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/classes/routine.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';

class SubtitleWidget extends StatelessWidget {
  final Routine routine;
  const SubtitleWidget({Key? key, required this.routine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final unit = Formatter.unitOfMass(
      routine.initialUnitOfMass,
      routine.unitOfMassEnum,
    );

    final weights = Formatter.numWithoutDecimal(routine.totalWeights);
    final duration = Formatter.durationInMin(routine.duration);
    final trainingLevel = Formatter.difficulty(routine.trainingLevel)!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            weights + ' ' + unit,
            style: TextStyles.body2_light,
          ),
          const Text('   \u2022   ', style: TextStyles.caption1),
          Text(
            '$duration ${S.current.minutes}',
            style: TextStyles.body2_light,
          ),
          const Text('   \u2022   ', style: TextStyles.caption1),
          Text(trainingLevel, style: TextStyles.body2_light)
        ],
      ),
    );
  }
}
