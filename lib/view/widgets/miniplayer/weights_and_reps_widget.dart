import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/models.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/view_models/miniplayer_model.dart';

class WeightsAndRepsWidget extends StatelessWidget {
  final MiniplayerModel model;

  const WeightsAndRepsWidget({
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width - 56;
    final height = size.width - 56;
    final columnWidth = (size.width - 56) / 2 - 0.5;

    final routine = model.currentWorkout! as Routine;
    final routineWorkout = model.currentRoutineWorkout!;
    final workoutSet = model.currentWorkoutSet!;

    final weights = Formatter.numWithOrWithoutDecimal(workoutSet.weights!);
    final unit = Formatter.unitOfMass(
      routine.initialUnitOfMass,
      routine.unitOfMassEnum,
    );

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Card(
        color: Colors.grey[800],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 6,
        child: SizedBox(
          width: width,
          height: height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: columnWidth,
                height: height,
                child: Stack(
                  children: [
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyles.body2,
                          children: <TextSpan>[
                            if (routineWorkout.isBodyWeightWorkout)
                              TextSpan(
                                text: S.current.bodyweight,
                                style: TextStyles.headline5,
                              ),
                            if (!routineWorkout.isBodyWeightWorkout)
                              TextSpan(
                                text: weights,
                                style: TextStyles.headline3,
                              ),
                            if (!routineWorkout.isBodyWeightWorkout)
                              TextSpan(text: unit),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            S.current.weights,
                            style: TextStyles.body2_grey,
                          ),
                        ),
                        const Divider(color: kBackgroundColor, height: 0),
                      ],
                    ),
                  ],
                ),
              ),
              Container(width: 1, color: kBottomNavBarColor),
              SizedBox(
                width: columnWidth,
                height: height,
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: TextStyles.headline3,
                              children: <TextSpan>[
                                TextSpan(text: '${workoutSet.reps}'),
                                const TextSpan(
                                  text: ' x',
                                  style: TextStyles.body2,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            S.current.reps,
                            style: TextStyles.body2_grey,
                          ),
                        ),
                        const Divider(color: kBackgroundColor, height: 0),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
