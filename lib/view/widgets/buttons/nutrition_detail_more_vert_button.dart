import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/view_models/home_screen_model.dart';
import 'package:workout_player/view_models/nutritions_detail_screen_model.dart';

import '../widgets.dart';

class NutritionDetailMoreVertButton extends StatelessWidget {
  const NutritionDetailMoreVertButton({
    Key? key,
    required this.database,
    required this.nutrition,
  }) : super(key: key);

  final Database database;
  final Nutrition nutrition;

  @override
  Widget build(BuildContext context) {
    final homeContext = HomeScreenModel.homeScreenNavigatorKey.currentContext!;

    return IconButton(
      icon: const Icon(Icons.more_vert_rounded),
      onPressed: () => showCustomModalBottomSheet(
        homeContext,
        title: NutritionsDetailScreenModel.title(nutrition),
        firstTileTitle: S.current.deletePascalCase,
        firstTileIcon: Icons.delete_rounded,
        firstTileOnTap: () => NutritionsDetailScreenModel().delete(
          context,
          database: database,
          nutrition: nutrition,
        ),
      ),
    );
  }
}