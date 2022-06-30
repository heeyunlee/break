import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/text_styles.dart';

class EmptyWorkoutSetWidget extends StatelessWidget {
  const EmptyWorkoutSetWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final paddingFactor = (size.height > 700) ? 56 : 104;

    return Card(
      color: Colors.grey[800],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 6,
      child: SizedBox(
        width: size.width - paddingFactor,
        height: size.width - paddingFactor,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/treadmill.png',
                height: size.width / 1.5,
                width: size.width / 1.5,
              ),
              Text(
                S.current.addSetsToWorkout,
                style: TextStyles.subtitle1Bold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
