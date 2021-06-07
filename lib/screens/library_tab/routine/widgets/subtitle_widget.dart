import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';

import '../../../../constants.dart';
import '../../../../format.dart';

class SubtitleWidget extends StatelessWidget {
  final Routine routine;
  const SubtitleWidget({Key? key, required this.routine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // FORMATTING
    final trainingLevel = Format.difficulty(routine.trainingLevel)!;
    final duration = Format.durationInMin(routine.duration);
    final weights = Format.weights(routine.totalWeights);
    final unitOfMass = Format.unitOfMass(routine.initialUnitOfMass);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            weights + ' ' + unitOfMass,
            style: kBodyText2Light,
          ),
          const Text('   \u2022   ', style: kCaption1),
          Text(
            '$duration ${S.current.minutes}',
            style: kBodyText2Light,
          ),
          const Text('   \u2022   ', style: kCaption1),
          Text(trainingLevel, style: kBodyText2Light)
        ],
      ),
    );
  }
}
