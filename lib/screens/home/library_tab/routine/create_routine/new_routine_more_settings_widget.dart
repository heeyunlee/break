import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/location.dart';
import 'package:workout_player/styles/constants.dart';

import 'create_new_routine_model.dart';

class NewRoutineMoreSettingsWidget extends StatelessWidget {
  final CreateNewROutineModel model;

  const NewRoutineMoreSettingsWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Location
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.place_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(S.current.location, style: kHeadline6Bold),
                ],
              ),
            ),
            Card(
              margin: EdgeInsets.zero,
              color: kCardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  isExpanded: true,
                  value: model.location,
                  dropdownColor: kCardColor,
                  decoration: const InputDecoration(
                    enabledBorder: InputBorder.none,
                  ),
                  style: kBodyText1,
                  onChanged: model.onChangedLocation,
                  items: [
                    DropdownMenuItem(
                      value: 'Location.gym',
                      child: Text(Location.gym.translation!),
                    ),
                    DropdownMenuItem(
                      value: 'Location.atHome',
                      child: Text(Location.atHome.translation!),
                    ),
                    DropdownMenuItem(
                      value: 'Location.outdoor',
                      child: Text(Location.outdoor.translation!),
                    ),
                    DropdownMenuItem(
                      value: 'Location.others',
                      child: Text(Location.others.translation!),
                    ),
                  ],
                ),
              ),
            ),

            /// Difficulty
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${S.current.difficulty}: ${model.routineDifficultyLabel}',
                style: kHeadline6Bold,
              ),
            ),
            Card(
              color: kCardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Slider(
                activeColor: kPrimaryColor,
                inactiveColor: kPrimaryColor.withOpacity(0.2),
                value: model.routineDifficulty,
                onChanged: model.onChangedDifficulty,
                label: model.routineDifficultyLabel,
                min: 0,
                max: 2,
                divisions: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
