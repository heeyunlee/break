import 'package:flutter/material.dart';
import 'package:workout_player/models/main_muscle_group.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/workout_set.dart';

import '../../constants.dart';
import '../../format.dart';

class WeightsAndRepsWidget extends StatelessWidget {
  const WeightsAndRepsWidget({
    Key key,
    this.workoutSet,
    this.routineWorkout,
    this.routine,
  }) : super(key: key);

  final WorkoutSet workoutSet;
  final RoutineWorkout routineWorkout;
  final Routine routine;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final weights = Format.weights(workoutSet.weights);
    final unit = UnitOfMass.values[routine.initialUnitOfMass].label;

    return Center(
      child: Card(
        color: Colors.grey[800],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 6,
        child: Container(
          width: size.width - 48,
          height: size.width - 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: (size.width - 56) / 2,
                child: Stack(
                  children: [
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: BodyText2,
                          children: <TextSpan>[
                            if (routineWorkout.isBodyWeightWorkout)
                              const TextSpan(text: 'Body + '),
                            TextSpan(
                              text: weights,
                              style: Headline3.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            TextSpan(text: unit),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        const Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Text('Weights', style: BodyText2Grey),
                        ),
                        const Divider(
                          color: BackgroundColor,
                          endIndent: 4,
                          indent: 4,
                          height: 0,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(width: 1, color: BackgroundColor),
              Container(
                width: (size.width - 56) / 2,
                child: Stack(
                  children: [
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: Headline3.copyWith(
                            color: Colors.white,
                          ),
                          children: <TextSpan>[
                            TextSpan(text: '${workoutSet.reps}'),
                            TextSpan(
                              text: ' x',
                              style: BodyText2.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text('Reps',
                              style: BodyText2.copyWith(color: Colors.grey)),
                        ),
                        const Divider(
                          color: BackgroundColor,
                          endIndent: 4,
                          indent: 4,
                          height: 0,
                        ),
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
