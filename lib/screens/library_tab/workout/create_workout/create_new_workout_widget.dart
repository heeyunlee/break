import 'package:flutter/material.dart';
import 'package:workout_player/screens/library_tab/workout/create_workout/create_new_workout_screen.dart';

import '../../../../constants.dart';

class CreateNewWorkoutWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 56,
        width: 56,
        color: Grey800,
        child: Icon(
          Icons.add_rounded,
          color: Grey200,
        ),
      ),
      title: Text(
        'Add new workout',
        style: BodyText1.copyWith(fontWeight: FontWeight.bold),
      ),
      onTap: () => CreateNewWorkoutScreen.show(context),
      onLongPress: () {},
    );
  }
}
