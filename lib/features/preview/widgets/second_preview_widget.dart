import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/dummy_data.dart';
import 'package:workout_player/features/widgets/widgets.dart';

class SecondPreviewWidget extends StatelessWidget {
  const SecondPreviewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: size.height / 3),
          Text(
            S.current.createYourOwnWorkoutRoutine,
            style: TextStyles.body1Menlo,
          ),
          SizedBox(height: size.height / 6),
          ...List.generate(
            4,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: RoutineWorkoutCard(
                index: index,
                routine: DummyData.routine,
                routineWorkout: DummyData.routineWorks[index],
              ),
            ),
          ),
          SizedBox(height: size.height / 2),
        ],
      ),
    );
  }
}
