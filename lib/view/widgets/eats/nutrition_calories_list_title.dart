import 'package:flutter/material.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view_models/nutritions_detail_screen_model.dart';

class NutritionCaloriesListTile extends StatelessWidget {
  const NutritionCaloriesListTile({Key? key, required this.nutrition})
      : super(key: key);

  final Nutrition nutrition;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      title: Text(S.current.calories, style: TextStyles.body1),
      trailing: Text(
        NutritionsDetailScreenModel.totalCalories(nutrition),
        style: TextStyles.body2Grey,
      ),
    );
  }
}
