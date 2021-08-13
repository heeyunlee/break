import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/classes/enum/equipment_required.dart';
import 'package:workout_player/classes/enum/location.dart';
import 'package:workout_player/classes/enum/main_muscle_group.dart';
import 'package:workout_player/styles/text_styles.dart';

import '../../../styles/constants.dart';
import 'search_category/search_category_screen.dart';
import 'search_category/search_category_widget.dart';

class SearchTabBodyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 96),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              S.current.byMuscleGroup,
              style: TextStyles.body1_w900_menlo,
            ),
          ),
          _MainMuscleGroupGridWidget(),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              S.current.byEquipment,
              style: TextStyles.body1_w900_menlo,
            ),
          ),
          _EquipmentRequiredGridWidget(),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              S.current.byLocation,
              style: TextStyles.body1_w900_menlo,
            ),
          ),
          _LocationGridWidget(),
          const SizedBox(height: 160),
        ],
      ),
    );
  }
}

class _MainMuscleGroupGridWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final itemWidth = size.width / 2;
    final itemHeight = size.width / 5.5;

    final List<Widget> _cards = MainMuscleGroup.values.map(
      (muscle) {
        return SearchCategoryWidget(
          color: kPrimaryColor,
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
      childAspectRatio: (itemWidth / itemHeight),
      crossAxisCount: 2,
      padding: const EdgeInsets.all(8),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: _cards,
    );
  }
}

class _EquipmentRequiredGridWidget extends StatelessWidget {
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
        childAspectRatio: (itemWidth / itemHeight),
        crossAxisCount: 2,
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: _cards,
      ),
    );
  }
}

class _LocationGridWidget extends StatelessWidget {
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
        childAspectRatio: (itemWidth / itemHeight),
        crossAxisCount: 2,
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: _cards,
      ),
    );
  }
}
