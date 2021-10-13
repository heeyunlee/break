import 'dart:ui';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/meal.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/styles/theme_colors.dart';
import 'package:workout_player/view_models/edit_nutrition_entry_screen_model.dart';
import 'package:workout_player/view_models/home_screen_model.dart';

import '../widgets.dart';

class NutritionMealTypeListTile extends StatelessWidget {
  const NutritionMealTypeListTile({
    Key? key,
    required this.nutrition,
  }) : super(key: key);

  final Nutrition nutrition;

  @override
  Widget build(BuildContext context) {
    final homeContext = HomeScreenModel.homeScreenNavigatorKey.currentContext!;
    final size = MediaQuery.of(context).size;

    return ListTile(
      onTap: () => showModalBottomSheet(
        context: homeContext,
        builder: (context) => Consumer(
          builder: (context, watch, child) {
            final model = watch(
              editNutritionEntryScreenModelProvider(nutrition),
            );

            return BlurredCard(
              child: SizedBox(
                height: size.height / 3 + 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(height: 32),
                    Text(S.current.mealType, style: TextStyles.body1Bold),
                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          clipBehavior: Clip.none,
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              const SizedBox(width: 16),
                              ..._chips(model),
                              const SizedBox(width: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: MaxWidthRaisedButton(
                        radius: 24,
                        color: ThemeColors.primary500,
                        buttonText: S.current.save,
                        onPressed: () => model.onPressSave(context),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: size.width - 32,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          S.current.cancel,
                          style: TextStyles.button1Grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: kBottomNavigationBarHeight),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      title: Text(S.current.mealType, style: TextStyles.body1),
      trailing: Text(
        EnumToString.convertToString(nutrition.type, camelCase: true),
        style: TextStyles.body2Grey,
      ),
    );
  }

  List<Widget> _chips(EditNutritionEntryScreenModel model) {
    return Meal.values
        .map(
          (type) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              shape: StadiumBorder(
                side: BorderSide(
                  color: (model.nutrition.type == type)
                      ? ThemeColors.primary300
                      : Colors.grey,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              label: Text(type.translation ?? '', style: TextStyles.button1),
              selected: model.nutrition.type == type,
              selectedShadowColor: ThemeColors.primary500,
              backgroundColor: ThemeColors.card,
              selectedColor: ThemeColors.primary500,
              onSelected: (selected) => model.onMealTypeSelected(
                selected,
                type,
              ),
            ),
          ),
        )
        .toList();
  }
}
