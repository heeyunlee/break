import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/text_styles.dart';

class EmptyWorkoutSetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Card(
        color: Colors.grey[800],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 6,
        child: SizedBox(
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
                Text(
                  S.current.addSetsToWorkout,
                  style: TextStyles.subtitle1_bold,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
