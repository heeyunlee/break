import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';

import '../../../styles/constants.dart';

class EmptyWorkoutSetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: Card(
        color: Colors.grey[800],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 6,
        child: Container(
          width: size.width - 56,
          height: size.width - 56,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/treadmill.png',
                  height: size.width / 1.5,
                  width: size.width / 1.5,
                ),
                Text(S.current.addSetsToWorkout, style: kSubtitle1Bold),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
