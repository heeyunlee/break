import 'package:flutter/material.dart';
import 'package:workout_player/models/enum/unit_of_mass.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/workout_set.dart';

import '../../constants.dart';
import '../../format.dart';

class WeightsAndRepsWidget extends StatefulWidget {
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
  _WeightsAndRepsWidgetState createState() => _WeightsAndRepsWidgetState();
}

class _WeightsAndRepsWidgetState extends State<WeightsAndRepsWidget> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final weights = Format.weights(widget.workoutSet.weights);
    final unit = UnitOfMass.values[widget.routine.initialUnitOfMass].label;

    return Center(
      child: Card(
        color: Colors.grey[800],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 6,
        child: SizedBox(
          width: size.width - 56,
          height: size.width - 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: (size.width - 56) / 2 - 0.5,
                height: size.width - 56,
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (!widget.routineWorkout.isBodyWeightWorkout)
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.add_rounded,
                                color: Colors.white,
                              ),
                            ),
                          RichText(
                            text: TextSpan(
                              style: BodyText2,
                              children: <TextSpan>[
                                if (widget.routineWorkout.isBodyWeightWorkout)
                                  const TextSpan(
                                    text: 'Bodyweight',
                                    style: Headline5,
                                  ),
                                if (!widget.routineWorkout.isBodyWeightWorkout)
                                  TextSpan(text: weights, style: Headline3),
                                if (!widget.routineWorkout.isBodyWeightWorkout)
                                  TextSpan(text: unit),
                              ],
                            ),
                          ),
                          if (!widget.routineWorkout.isBodyWeightWorkout)
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.remove_rounded,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text('Weights', style: BodyText2Grey),
                        ),
                        const Divider(color: BackgroundColor, height: 0),
                      ],
                    ),
                  ],
                ),
              ),
              Container(width: 1, color: BackgroundColor),
              SizedBox(
                height: size.width - 56,
                width: (size.width - 56) / 2 - 0.5,
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: Headline3,
                              children: <TextSpan>[
                                TextSpan(text: '${widget.workoutSet.reps}'),
                                const TextSpan(text: ' x', style: BodyText2),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.remove_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text('Reps', style: BodyText2Grey),
                        ),
                        const Divider(color: BackgroundColor, height: 0),
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
