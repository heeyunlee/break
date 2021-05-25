import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/unit_of_mass.dart';

import '../../../constants.dart';
import '../../../format.dart';
import '../provider/workout_miniplayer_provider.dart';

class WeightsAndRepsWidget extends ConsumerWidget {
  final double width;
  final double height;

  const WeightsAndRepsWidget({
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final miniplayerProvider = watch(miniplayerProviderNotifierProvider);
    final routine = miniplayerProvider.selectedRoutine!;
    final routineWorkout = miniplayerProvider.currentRoutineWorkout!;
    final workoutSet = miniplayerProvider.currentWorkoutSet!;
    // final routine = watch(selectedRoutineProvider).state!;
    // final routineWorkout = watch(currentRoutineWorkoutProvider).state!;
    // final workoutSet = watch(currentWorkoutSetProvider).state!;

    final weights = Format.weights(workoutSet.weights!);
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
                              style: kBodyText2,
                              children: <TextSpan>[
                                if (routineWorkout.isBodyWeightWorkout)
                                  TextSpan(
                                    text: S.current.bodyweight,
                                    style: kHeadline5,
                                  ),
                                if (!routineWorkout.isBodyWeightWorkout)
                                  TextSpan(text: weights, style: kHeadline3),
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
                              style: kHeadline3,
                              children: <TextSpan>[
                                TextSpan(text: '${workoutSet.reps}'),
                                const TextSpan(text: ' x', style: kBodyText2),
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
