import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:workout_player/screens/protein/add_protein_screen.dart';
import 'package:workout_player/screens/search_tab/start_workout_shortcut_screen.dart';

import '../constants.dart';

class SpeedDialFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.add_rounded,
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: PrimaryColor,
      overlayColor: Color(0xff1C1C1C),
      animationSpeed: 100,
      children: [
        SpeedDialChild(
          labelWidget: const Text('Add Protein', style: ButtonText),
          backgroundColor: Primary600Color,
          onTap: () => AddProteinScreen.show(context),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 24, maxWidth: 24),
            child: const Icon(Icons.set_meal_rounded, color: Colors.white),
          ),
        ),
        SpeedDialChild(
          labelWidget: const Text('Start Workout', style: ButtonText),
          backgroundColor: Primary700Color,
          onTap: () => StartWorkoutShortcutScreen.show(context),
          child: const Icon(Icons.fitness_center_rounded, color: Colors.white),
        ),
      ],
    );
  }
}
