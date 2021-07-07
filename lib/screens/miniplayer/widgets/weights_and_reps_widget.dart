import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/unit_of_mass.dart';
import 'package:workout_player/styles/text_styles.dart';

import '../../../styles/constants.dart';
import '../../../utils/formatter.dart';
import '../miniplayer_model.dart';

class WeightsAndRepsWidget extends StatelessWidget {
  final double width;
  final double height;
  final MiniplayerModel model;

  const WeightsAndRepsWidget({
    required this.width,
    required this.height,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final routine = model.selectedRoutine!;
    final routineWorkout = model.currentRoutineWorkout!;
    final workoutSet = model.currentWorkoutSet!;

    final weights = Formatter.weights(workoutSet.weights!);
    final unit = UnitOfMass.values[routine.initialUnitOfMass].label;

    return Center(
      child: Card(
        color: Colors.grey[800],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 6,
        child: SizedBox(
          width: width,
          height: height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: width / 2 - 0.5,
                height: height,
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // if (!widget.routineWorkout.isBodyWeightWorkout)
                          //   IconButton(
                          //     onPressed: () {},
                          //     icon: const Icon(
                          //       Icons.add_rounded,
                          //       color: Colors.white,
                          //     ),
                          //   ),
                          RichText(
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
                          // if (!widget.routineWorkout.isBodyWeightWorkout)
                          //   IconButton(
                          //     onPressed: () {},
                          //     icon: const Icon(
                          //       Icons.remove_rounded,
                          //       color: Colors.white,
                          //     ),
                          //   ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(S.current.weights, style: kBodyText2Grey),
                        ),
                        const Divider(color: kBackgroundColor, height: 0),
                      ],
                    ),
                  ],
                ),
              ),
              Container(width: 1, color: kBackgroundColor),
              SizedBox(
                width: width / 2 - 0.5,
                height: height,
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // IconButton(
                          //   onPressed: () {},
                          //   icon: const Icon(
                          //     Icons.add_rounded,
                          //     color: Colors.white,
                          //   ),
                          // ),
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
                          // IconButton(
                          //   onPressed: () {},
                          //   icon: const Icon(
                          //     Icons.remove_rounded,
                          //     color: Colors.white,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(S.current.reps, style: kBodyText2Grey),
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
