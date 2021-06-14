import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';

import '../../../../styles/constants.dart';
import '../../../../utils/formatter.dart';

class SubtitleWidget extends StatelessWidget {
  final Routine routine;
  const SubtitleWidget({Key? key, required this.routine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // FORMATTING
    final trainingLevel = Formatter.difficulty(routine.trainingLevel)!;
    final duration = Formatter.durationInMin(routine.duration);
    final weights = Formatter.weights(routine.totalWeights);
    final unitOfMass = Formatter.unitOfMass(routine.initialUnitOfMass);

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
