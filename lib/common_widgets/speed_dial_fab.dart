import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:workout_player/generated/l10n.dart';
// import 'package:workout_player/screens/speed_dial_screens/add_measurement_screen.dart';
import 'package:workout_player/screens/speed_dial_screens/add_protein_screen.dart';
import 'package:workout_player/screens/speed_dial_screens/start_workout_shortcut_screen.dart';

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
          labelWidget: Text(S.current.addProteinButtonText, style: ButtonText),
          backgroundColor: Primary600Color,
          onTap: () => AddProteinScreen.show(context),
          child: const Icon(Icons.restaurant_menu_rounded, color: Colors.white),
        ),
        SpeedDialChild(
          labelWidget: Text(
            S.current.startWorkoutButtonText,
            style: ButtonText,
          ),
          backgroundColor: Primary700Color,
          onTap: () => StartWorkoutShortcutScreen.show(context),
          child: const Icon(Icons.fitness_center_rounded, color: Colors.white),
        ),
        // SpeedDialChild(
        //   labelWidget: Text(
        //     S.current.addMeasurement,
        //     style: ButtonText,
        //   ),
        //   backgroundColor: Primary800Color,
        //   onTap: () => AddMeasurementScreen.show(context),
        //   child: Center(
        //     child: const FaIcon(FontAwesomeIcons.weight, color: Colors.white),
        //   ),
        // ),
      ],
    );
  }
}
