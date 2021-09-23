import 'package:flutter/material.dart';

import 'package:workout_player/models/enum/meal.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/styles/theme_colors.dart';

import '../../../../../view_models/add_nutrition_screen_model.dart';

class ChooseMealTypeWidget extends StatelessWidget {
  final AddNutritionScreenModel model;

  const ChooseMealTypeWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(S.current.mealType, style: TextStyles.caption1),
        ),
        SingleChildScrollView(
          clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: Meal.values
                .map(
                  (type) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: (model.mealType == type)
                              ? ThemeColors.primary300
                              : Colors.grey,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      label: Text(
                        type.translation ?? '',
                        style: TextStyles.button1,
                      ),
                      selected: model.mealType == type,
                      selectedShadowColor: ThemeColors.primary500,
                      backgroundColor: ThemeColors.background,
                      selectedColor: ThemeColors.primary500,
                      onSelected: (bool selected) => model.onChipSelected(
                        selected,
                        type,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
