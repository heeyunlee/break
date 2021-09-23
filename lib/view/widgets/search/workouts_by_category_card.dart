import 'package:flutter/material.dart';
import 'package:workout_player/models/enum/equipment_required.dart';
import 'package:workout_player/models/enum/location.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/styles/theme_colors.dart';

import '../../screens/search_category_screen.dart';
import 'search_category_widget.dart';

class WorkoutsByCategoryCard extends StatelessWidget {
  const WorkoutsByCategoryCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final List<Widget> _mainMuscleGroupCards = MainMuscleGroup.values.map(
      (muscle) {
        return SearchCategoryWidget(
          text: muscle.translation!,
          onTap: () => SearchCategoryScreen.show(
            context,
            arrayContains: muscle.toString(),
            searchCategory: 'mainMuscleGroup',
          ),
        );
      },
    ).toList();

    final List<Widget> _equipmentsCards = EquipmentRequired.values.map(
      (equipment) {
        return SearchCategoryWidget(
          color: ThemeColors.secondary,
          text: equipment.translation!,
          onTap: () => SearchCategoryScreen.show(
            context,
            arrayContains: equipment.toString(),
            searchCategory: 'equipmentRequired',
          ),
        );
      },
    ).toList();

    final List<Widget> _locationCards = Location.values.map(
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

    final _cards = [
      ..._mainMuscleGroupCards,
      ..._equipmentsCards,
      ..._locationCards,
    ]..shuffle();

    return SizedBox(
      height: size.height / 3.65,
      child: GridView.count(
        scrollDirection: Axis.horizontal,
        childAspectRatio: 0.4,
        crossAxisCount: 3,
        padding: const EdgeInsets.all(8),
        shrinkWrap: true,
        children: _cards,
      ),
    );
  }
}
