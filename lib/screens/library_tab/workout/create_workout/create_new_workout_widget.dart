import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';

import '../../../../constants.dart';
import 'create_new_workout_screen.dart';

class CreateNewWorkoutWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint('CreateNewWorkoutWidget building...');

    return GestureDetector(
      onTap: () => CreateNewWorkoutScreen.show(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Card(
          color: Colors.transparent,
          elevation: 0,
          child: Row(
            children: <Widget>[
              Container(
                width: 64,
                height: 64,
                color: kGrey800,
                child: const Icon(Icons.add_rounded, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Text(S.current.createNewWorkout, style: kBodyText1Bold),
            ],
          ),
        ),
      ),
    );
  }
}
