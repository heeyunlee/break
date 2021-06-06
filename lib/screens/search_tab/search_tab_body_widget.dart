import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/equipment_required.dart';
import 'package:workout_player/models/enum/location.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';

import '../../constants.dart';
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
              style: kBodyText1Menlow900,
            ),
          ),
          _MainMuscleGroupGridWidget(),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              S.current.byEquipment,
              style: kBodyText1Menlow900,
            ),
          ),
          _EquipmentRequiredGridWidget(),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              S.current.byLocation,
              style: kBodyText1Menlow900,
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
    var _mainMuscleGroup = MainMuscleGroup.values[0].list;
    var _mainMuscleGroupTranslated = MainMuscleGroup.values[0].translatedList;

    var gridTiles = <Widget>[];

    for (var i = 0; i < _mainMuscleGroup.length; i++) {
      Widget card = SearchCategoryWidget(
        color: kPrimaryColor,
        text: _mainMuscleGroupTranslated[i],
        onTap: () => SearchCategoryScreen.show(
          context,
          arrayContains: _mainMuscleGroup[i],
          searchCategory: 'mainMuscleGroup',
        ),
      );

      gridTiles.add(card);
    }

    final size = MediaQuery.of(context).size;

    final itemWidth = size.width / 2;
    final itemHeight = size.width / 5.5;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        childAspectRatio: (itemWidth / itemHeight),
        crossAxisCount: 2,
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: gridTiles,
      ),
    );
  }
}

class _EquipmentRequiredGridWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _equipmentRequired = EquipmentRequired.values[0].list;
    var _equipmentRequiredTranslated =
        EquipmentRequired.values[0].translatedList;

    var gridTiles = <Widget>[];

    for (var i = 0; i < _equipmentRequired.length; i++) {
      Widget card = SearchCategoryWidget(
        color: kSecondaryColor,
        text: _equipmentRequiredTranslated[i],
        onTap: () => SearchCategoryScreen.show(
          context,
          arrayContains: _equipmentRequired[i],
          searchCategory: 'equipmentRequired',
        ),
      );

      gridTiles.add(card);
    }

    final size = MediaQuery.of(context).size;

    final itemWidth = size.width / 2;
    final itemHeight = size.width / 5.5;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        childAspectRatio: (itemWidth / itemHeight),
        crossAxisCount: 2,
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: gridTiles,
      ),
    );
  }
}

class _LocationGridWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _location = Location.values[0].list;
    var _locationTranslated = Location.values[0].translatedList;

    var gridTiles = <Widget>[];

    for (var i = 0; i < _location.length; i++) {
      Widget card = SearchCategoryWidget(
        color: Colors.amber,
        text: _locationTranslated[i],
        onTap: () => SearchCategoryScreen.show(
          context,
          isEqualTo: _location[i],
          searchCategory: 'location',
        ),
      );

      gridTiles.add(card);
    }

    final size = MediaQuery.of(context).size;

    final itemWidth = size.width / 2;
    final itemHeight = size.width / 5.5;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        childAspectRatio: (itemWidth / itemHeight),
        crossAxisCount: 2,
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: gridTiles,
      ),
    );
  }
}
