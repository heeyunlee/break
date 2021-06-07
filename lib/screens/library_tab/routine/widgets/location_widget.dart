import 'package:flutter/material.dart';
import 'package:workout_player/models/enum/location.dart';
import 'package:workout_player/models/routine.dart';

import '../../../../constants.dart';

class LocationWidget extends StatelessWidget {
  final Routine routine;

  const LocationWidget({Key? key, required this.routine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _location = Location.values
        .firstWhere((e) => e.toString() == routine.location)
        .translation!;

    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 24),
      child: Row(
        children: [
          const Icon(
            Icons.location_on_rounded,
            size: 20,
            color: Colors.white,
          ),
          const SizedBox(width: 16),
          Text(_location, style: kBodyText1),
        ],
      ),
    );
  }
}
