import 'package:flutter/material.dart';
import 'package:workout_player/screens/during_workout/during_workout_screen.dart';

import '../constants.dart';

class CustomFloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: PrimaryColor,
      child: IconButton(
        icon: Icon(
          Icons.add_rounded,
          color: Colors.white,
        ),
      ),
      onPressed: () => DuringWorkoutScreen.show(
        context: context,
      ),
    );
  }
}
