import 'package:flutter/material.dart';
import 'package:workout_player/models/enum/equipment_required.dart';
import 'package:workout_player/models/enum/location.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';

import '../../../styles/constants.dart';
import '../../screens/search_category_screen.dart';
import 'search_category_widget.dart';

class MainMuscleGroupGridWidget extends StatelessWidget {
  const MainMuscleGroupGridWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final itemWidth = size.width / 2;
    final itemHeight = size.width / 5.5;

    final List<Widget> _cards = MainMuscleGroup.values.map(
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

    return GridView.count(
      childAspectRatio: itemWidth / itemHeight,
      crossAxisCount: 2,
      padding: const EdgeInsets.all(8),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: _cards,
    );
  }
}

class EquipmentRequiredGridWidget extends StatelessWidget {
  const EquipmentRequiredGridWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final itemWidth = size.width / 2;
    final itemHeight = size.width / 5.5;

    final List<Widget> _cards = EquipmentRequired.values.map(
      (equipment) {
        return SearchCategoryWidget(
          color: kSecondaryColor,
          text: equipment.translation!,
          onTap: () => SearchCategoryScreen.show(
            context,
            arrayContains: equipment.toString(),
            searchCategory: 'equipmentRequired',
          ),
        );
      },
    ).toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        childAspectRatio: itemWidth / itemHeight,
        crossAxisCount: 2,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: _cards,
      ),
    );
  }
}

class LocationGridWidget extends StatelessWidget {
  const LocationGridWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final itemWidth = size.width / 2;
    final itemHeight = size.width / 5.5;

    final List<Widget> _cards = Location.values.map(
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

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        childAspectRatio: itemWidth / itemHeight,
        crossAxisCount: 2,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: _cards,
      ),
    );
  }
}
