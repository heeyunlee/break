import 'package:flutter/material.dart';
import 'package:workout_player/models/enum/equipment_required.dart';
import 'package:workout_player/models/enum/location.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';

import '../../screens/search_category_screen.dart';
import 'search_category_widget.dart';

class WorkoutsByCategoryCard extends StatelessWidget {
  const WorkoutsByCategoryCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    final List<Widget> mainMuscleGroupCards = MainMuscleGroup.values.map(
      (muscle) {
        return SearchCategoryWidget(
          color: theme.primaryColor,
          text: muscle.translation!,
          onTap: () => SearchCategoryScreen.show(
            context,
            arrayContains: muscle.toString(),
            searchCategory: 'mainMuscleGroup',
          ),
        );
      },
    ).toList();

    final List<Widget> equipmentsCards = EquipmentRequired.values.map(
      (equipment) {
        return SearchCategoryWidget(
          color: theme.colorScheme.secondary,
          text: equipment.translation!,
          onTap: () => SearchCategoryScreen.show(
            context,
            arrayContains: equipment.toString(),
            searchCategory: 'equipmentRequired',
          ),
        );
      },
    ).toList();

    final List<Widget> locationCards = Location.values.map(
      (location) {
        return SearchCategoryWidget(
          color: Colors.amber,
          text: location.translation!,
          onTap: () => SearchCategoryScreen.show(
            context,
            searchCategory: 'location',
            isEqualTo: location.toString(),
          ),
        );
      },
    ).toList();

    final cards = [
      ...mainMuscleGroupCards,
      ...equipmentsCards,
      ...locationCards,
    ]..shuffle();

    return SizedBox(
      height: size.height / 3.65,
      child: GridView.count(
        scrollDirection: Axis.horizontal,
        childAspectRatio: 0.4,
        crossAxisCount: 3,
        padding: const EdgeInsets.all(8),
        shrinkWrap: true,
        children: cards,
      ),
    );
  }
}
