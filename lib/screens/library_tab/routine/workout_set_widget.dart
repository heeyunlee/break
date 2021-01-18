import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/models/workout_set.dart';

import '../../../constants.dart';

class WorkoutSetWidget extends StatelessWidget {
  const WorkoutSetWidget({
    Key key,
    // this.routine,
    // this.routineWorkout,
    // this.database,
    this.set,
    this.onPressed,
  }) : super(key: key);

  // final Routine routine;
  // final RoutineWorkout routineWorkout;
  // final Database database;
  final WorkoutSet set;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 16, height: 56),
        if (!set.isRest) Text(set.setTitle, style: BodyText1Bold),
        if (set.isRest) Icon(Icons.timer_rounded, color: Colors.grey, size: 20),
        Spacer(),
        if (!set.isRest)
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              height: 32,
              width: 80,
              alignment: Alignment.center,
              color: PrimaryColor,
              child: Text(
                '${set.weights} kg',
                style: BodyText1,
              ),
            ),
          ),
        SizedBox(width: 16),
        if (!set.isRest)
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              height: 32,
              width: 72,
              padding: EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.center,
              color: PrimaryColor,
              child: Text('${set.reps} x', style: BodyText1),
            ),
          ),
        if (set.isRest)
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              height: 32,
              width: 72,
              padding: EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.center,
              color: Color(0xff3C3C3C),
              child: Text('${set.restTime} 초', style: BodyText1),
            ),
          ),
        IconButton(
          icon: Icon(Icons.more_vert_rounded, color: Colors.grey),
          onPressed: onPressed,
        ),
      ],
    );
  }
}
